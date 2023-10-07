import numpy as np
from scipy.linalg import expm
import time 

  
    
def MyExp(M):
    if len(M.shape) > 1:
        f = expm(M)
    else:
        f = np.diag(np.exp(M))
    return f


def MyRound(x):
  return x - np.round(x)


def Remap_Eulerian_q( q, pbc):

    pbc['L'] = np.dot(MyExp(pbc['Y']*pbc['theta']) , pbc['L0'])
    pbc['Linv'] = np.dot( pbc['L0inv'], MyExp(-pbc['Y']*pbc['theta']))
    q = np.dot(pbc['L'], MyRound(np.dot(pbc['Linv'], q)))
    return q, pbc

def fLJ(rr, param):
  if rr > param['rcut']:
      p = 0.0
  else:
      p = 4 * param['eps'] * ((12 * param['sigm'] ** 6) / rr ** 7 - (12 * param['sigm'] ** 12) / rr ** 13)
  return p


class Fun:
    def __init__(self,param,pbc):
        self.param = param
        self.pbc = pbc
  
    def initializez(self,X):
        nPart = self.param['nPart']
        dim = self.param['dim']
        beta = self.param['beta']
        A = self.pbc['A']

        if dim == 3:
            ll = 0
            for l in range(nPart):
                i = l+1
                j = i+1
                X.q[:,ll] = [(0.5 + i-0.5*nPart)/nPart,
                            (0.5 + j-0.5*nPart)/nPart,
                            (0.5 + l-0.5*nPart)/nPart]
                ll += 1
        else:
            ll = 0
            for l in range(nPart):
                j = l+1
                X['q'][:,ll] = [(0.5 + l-0.5*nPart)/nPart,
                            (0.5 + j-0.5*nPart)/nPart,
                            0]
                ll += 1

        X['q'] = np.dot(self.pbc['L'], X['q'])
        X['q'][0:dim,:] = X['q'][0:dim,:] + 0.05 * np.random.randn(dim, nPart)
        X['p'] = np.dot(A, X['q'])
        X['p'][0:dim,:] = X['p'][0:dim,:] + np.sqrt(1/beta) * np.random.randn(dim, nPart)
        return X
    
    def ComputeForceEulerian(self,X,pbc):
        nPart = self.param['nPart']
        dim = self.param['dim']

        mm1 = 1
        mm2 = 1
        X['f'][:dim,:] = np.zeros((dim, nPart))
        for i in range(nPart-1):
            for j in range(i+1, nPart):
                X['qDist'] = X['q'][:, i] - X['q'][:, j]
                X['qDist'], _ = Remap_Eulerian_q(X['qDist'], pbc)
                normqD = np.linalg.norm(X['qDist'])
                ff = fLJ(normqD, self.param)
                X['f'][:, i] = X['f'][:, i] - ff * X['qDist'] / normqD
                X['f'][:, j] = X['f'][:, j] + ff * X['qDist'] / normqD
                if mm1 < abs(ff):
                    mm1 = abs(ff)
                    mm2 = ff

        X['ff'] = mm2
        return X

    def EmEulerian(self,X, pbc):
        nPart = self.param['nPart']
        dim = self.param['dim']
        dt = self.pbc['dt']
        gamma = self.param['gamma']
        beta = self.param['beta']


        # Update position
        X['q'] = X['q'] + (X['p'] + np.dot(pbc['A'] , X['q'])) * dt

        # Compute force
        X = self.ComputeForceEulerian(X, pbc)
        # X = ComputeForceEulerianCell(X, param, pbc, Z)
        # Update momentum
        X['G'][:dim, :nPart] = np.sqrt(2 *dt * gamma / beta) * np.random.randn(dim, nPart)

        X['p'] = X['p'] + X['f'] * dt - gamma * X['p'] * dt + X['G']

        # Remap position
        X['q'], pbc = Remap_Eulerian_q(X['q'], pbc)

        return X, pbc



    def Simulation(self,X, pbc,sav): 
         

        X = self.initializez(X)
        X,pbc = self.EmEulerian(X,pbc)
        tic = time.time() 
        for j in range(pbc['Nperiod']):
            fmax = 1e-16
            for i in range(pbc['N']): 
                sav['Q1'][i, j] = X['qDist'][0]
                sav['Q2'][i, j] = X['qDist'][1]
                sav['F'][i, j] = X['ff']
                t = 1e-3 * round(1e3 * (i - 1) * pbc['dt'])
                X, pbc = self.EmEulerian(X, pbc)
                pbc['theta1'] = pbc['theta'] + pbc['Sigma'] * pbc['dt']
                pbc['theta'] = pbc['theta1'] - np.floor(pbc['theta1'])
                pbc['n'] = pbc['n'] + pbc['theta'] - pbc['theta1']
                if np.abs(fmax) < np.abs(X['ff']):
                    fmax = X['ff']
            if np.mod(j, np.round(pbc['Nperiod'] / 10)) == 0:
                time_ = time.time()
                print(f"Period {j} executed in {np.round(1000*(time_-tic)/60)/1000} min")
                print(fmax)
        print('force : ',fmax)
        return sav
