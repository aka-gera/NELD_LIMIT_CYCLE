import numpy as np


class PBCs:
    def __init__(self) -> None:
        pass
    
    def Parameter(self,flow, epsilon, nPart, rcut, N, Nperiod):

        if nPart < 2:
            raise ValueError("The number of particles is invalid")


        if flow == 'eld':
            if nPart <= 2:
                a = 10
            else:
                a = 2*nPart
            A = np.array([[0,0,0],[0,0,0],[0,0,0]])
            invL0 = np.eye(3)/a
            Y = A
            Yoff = np.zeros((3,3))
            Sigma = 1
            dim = 2
        elif flow == 'shear':
            # Shear flow case with LE
            if nPart <= 2:
                a = 10
            else:
                a = 2*nPart
            A = epsilon * np.array([[0, 1, 0], [0, 0, 0], [0, 0, 0]])
            invL0 = np.eye(3) / a
            Y = A
            Yoff = np.zeros((3, 3))
            Sigma = epsilon
            dim = 2
        elif flow == 'pef':
            # PEF case with KR
            if nPart <= 4:
                a = 20
            else:
                a = 6*nPart

            A = epsilon * np.array([[-1, 0, 0], [0, 1, 0], [0, 0, 0]])
            M = np.array([[2, -1, 0], [-1, 1, 0], [0, 0, 1]])
            _,V = np.linalg.eig(M)
            V = np.dot([[-1, 0, 0],[0, -1, 0],[0, 0, 1]], V[:, [1, 0, 2]])
            Y = np.log(np.diag(np.dot(np.dot(np.linalg.inv(V), M), V)))
            Yoff = np.zeros((3, 3))
            invL0 = V / np.abs(np.linalg.det(V)) ** (1/2) / a 
            Sigma = -epsilon/Y[0]
    
        pbc = {}

        pbc['flow'] = flow
        pbc['L0inv'] = invL0
        pbc['L0'] = np.linalg.inv(invL0)
        pbc['Linv'] = pbc['L0inv']
        pbc['L'] = pbc['L0']
        pbc['A'] = A
        pbc['Y'] = Y
        pbc['Yoff'] = Yoff
        pbc['Sigma'] = Sigma
        pbc['T'] = 1/abs(Sigma)
        pbc['theta'] = 0
        pbc['theta1'] = 0
        pbc['n'] = 0
        pbc['dt'] = pbc['T'] / N
        pbc['N'] = N
        pbc['Nperiod'] = Nperiod

        part = {}


        part['q'] = np.zeros((3,nPart))
        part['qDist'] = np.zeros((3,nPart))
        part['p'] = np.zeros((3,nPart))
        part['p'][2,:nPart] = np.zeros(nPart)
        part['f'] = np.zeros((3,nPart))
        part['ff'] = np.zeros(1)
        part['G'] = np.zeros((3,nPart))

        sav = {}

        sav['Q1'] = np.zeros((N,Nperiod))
        sav['Q2'] = np.zeros((N,Nperiod))
        sav['F'] = np.zeros((N,Nperiod))


        dim = A.shape[0]-1

        param = {}

        param['sigm'] = 4
        param['eps'] = 1
        param['rcut'] = rcut
        param['dim'] = dim
        param['gamma'] = 0.1
        param['beta'] = 1
        param['a'] = a
        param['nPart'] = nPart
        param['Mmax'] = int(np.ceil(a/rcut*nPart))
        param['vol'] = a**3 * nPart

        Clist_Mmax = int(np.floor(a*dim/param['rcut']))
        Clist_head = np.zeros((param['Mmax']**3,1))
        Clist_list = np.zeros((nPart,1))
        Clist_mc = np.zeros((1,3))
        Clist_da = np.zeros((1,3))
        Clist_nL = np.zeros((1,3))
        Clist_c = np.zeros((1))
        Clist_lc = np.zeros((1,3))
        Clist_region = np.zeros((1,3))
        Clist_M = np.zeros((1,3))

        Clist = {'Mmax': Clist_Mmax,
                'head': Clist_head,
                'lis': Clist_list,
                'mc': Clist_mc,
                'da': Clist_da,
                'nL': Clist_nL,
                'c': Clist_c,
                'lc': Clist_lc,
                'region': Clist_region,
                'M': Clist_M}
        return pbc, param, Clist, part, sav
     
    def paramFig(self,PBC, sbox):
        mm = 100
        lSpace = np.linspace(1, np.exp(1), mm)
        II = np.ones(mm)
        I0 = np.zeros(mm)
        III = II - np.log(lSpace)

        dat = {
            'mapp': [II, III, III],
            'MainBoxColor': [1, 0, 0],
            'MainBoxEdge': ':',
            'MainBoxOpaque': 0.05,
            'MainBoxMarkerWidth': 1,
            'Color': 'r',
            'GridEdge': 'o',
            'GridColor': [0, 0, 0],
            'GridMarkerWidth': 2,
            'ft': 20,
            'AxisWidth': 3,
            'AxisColor': 'b',
            'aa': 15,
            'bb': 1
        }

        if PBC == 'eld':
            dat['mapp'] = [II, I0, I0]
            dat['Angle'] = [0, 90]
            dat['posTextX'] = -2
            dat['posTextY'] = 4
            dat['posTextZ'] = 7
            dat['aa'] = 0
            dat['bb'] = 20
            dat['xmin'] = -1.1 * sbox
            dat['xmax'] = 2.1 * sbox
            dat['ymin'] = -1.01 * sbox
            dat['ymax'] = 2.01 * sbox
            dat['zmin'] = -1.9 * sbox
            dat['zmax'] = 1.17 * sbox
            dat['center'] = [0, 0, 1]
            dat['radius'] = 1.5
            dat['centerOff'] = 0
        elif PBC == 'shear':
            dat['mapp'] = [II, I0, I0]
            dat['Angle'] = [0, 90]
            dat['posTextX'] = -2
            dat['posTextY'] = 4
            dat['posTextZ'] = 7
            dat['aa'] = 0
            dat['bb'] = 20
            dat['xmin'] = -1.1 * sbox
            dat['xmax'] = 2.1 * sbox
            dat['ymin'] = -1.01 * sbox
            dat['ymax'] = 2.01 * sbox
            dat['zmin'] = -1.9 * sbox
            dat['zmax'] = 1.17 * sbox
            dat['center'] = [0, 0, 1]
            dat['radius'] = 1.5
            dat['centerOff'] = 0
        elif PBC == 'pef':
            dat['mapp'] = [II, I0, I0]
            dat['Angle'] = [180, 90]
            dat['posTextX'] = 0
            dat['posTextY'] = -5
            dat['posTextZ'] = 7
            dat['aa'] = 0
            dat['bb'] = 20
            dat['xmin'] = -2.7 * sbox
            dat['xmax'] = 2.3 * sbox
            dat['ymin'] = -1.7 * sbox
            dat['ymax'] = 1.7 * sbox
            dat['zmin'] = -1.9 * sbox
            dat['zmax'] = 1.17 * sbox
            dat['center'] = [-0.75, -0.3, 1]
            dat['radius'] = -1.75
            dat['centerOff'] = 0.4

        dat['Axi'] = [dat['xmin'], dat['xmax'], dat['ymin'], dat['ymax'], dat['zmin'], dat['zmax']]

        xlength = 2.5
        ylength = 2  # Assuming there was an error in the MATLAB code where "2.5" shouldn't be here

        dat['xmax'] = sbox# xlength * sbox  # size of x dimension of graph
        dat['ymax'] = sbox# ylength * sbox  # size of y dimension of graph
        dat['zmax'] = 1  # size of z dimension of graph

        aa = dat['xmax']+xlength * sbox
        bb = dat['ymax']+ylength * sbox
        cc = dat['zmax']

        x = np.arange(-aa, aa + 1)
        y = np.arange(-bb, bb + 1)
        z = np.arange(-cc, cc + 1)

        xx, yy, zz = np.meshgrid(x, y, z)

        dat['PP'] = np.column_stack((xx.ravel(), yy.ravel(), zz.ravel()))  
        

        return dat
    
    def data_replicas(self,L, q, dat, param):
        # Input
        # L : simulation box in 2 dimensions
        # q : position of the particles
        # dat : unit Lattice grid

        # Output
        # qq : position of the particles in the simulation box and its replicas
        # Lk : simulation box in 3 dimensions
        # LB : simulation box with its replicas

        LL = np.dot(L, dat['PP'].T)
        # inds =  (LL[0, :] < dat['xmax']) & (LL[0, :] > -dat['xmax']) \
        #       & (LL[1, :] < dat['ymax']) & (LL[1, :] > -dat['ymax']) \
        #       & (LL[2, :] < dat['zmax']) & (LL[2, :] > -dat['zmax'])

        mm = q.shape[1]
        LB = LL#[:, inds] 
        nn = LB.shape[1] 
        qL = LB[0:3, :] 

        qTemp = qL + np.tile(q[:, 0], (1, nn)).reshape(nn,3).T 
        indsTemp = (qTemp[0, :] < dat['xmax']) & (qTemp[0, :] > -dat['xmax']) \
                & (qTemp[1, :] < dat['ymax']) & (qTemp[1, :] > -dat['ymax'])  \
                & (qTemp[2, :] < dat['zmax']) & (qTemp[2, :] > -dat['zmax']) 
        
        qq =qTemp[:,indsTemp]

        for i in range(mm-1): 
            qTemp = qL + np.tile(q[:, i+1], (1, nn)).reshape(nn,3).T 
            indsTemp = (qTemp[0, :] < dat['xmax']) & (qTemp[0, :] > -dat['xmax']) \
                & (qTemp[1, :] < dat['ymax']) & (qTemp[1, :] > -dat['ymax'])  \
                & (qTemp[2, :] < dat['zmax']) & (qTemp[2, :] > -dat['zmax']) 
            qq =np.hstack((qq, qTemp[:,indsTemp]))
            
        return qq
    
