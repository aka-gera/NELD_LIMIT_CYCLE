
import dash
from dash import dcc
from dash import html
from dash import Dash, dcc, html, dash_table, Input, Output, State, callback
from dash.dependencies import Input, Output, State
from jupyter_dash import JupyterDash 
from dash import no_update
import dash_bootstrap_components as dbc



import numpy as np
 

from NELD.param import PBCs
from NELD.Graph import mygraph
from NELD.CompFun import Fun as myFun


tcouleur = 'plotly_dark'
bcouleur = 'navy'
fcouleur = 'white'
fsize = 20
   

np.random.seed(0)


PBCs = PBCs()
mygraph = mygraph(tcouleur=tcouleur,
                  bcouleur=bcouleur,
                  fcouleur=fcouleur,
                  fsize=fsize)



########################## APP BEGIN ###########################################################

shw = 0

dropdown_options_style = {'color': 'white', 'background-color' : 'gray'}

dropdown_options = [
    {'label': 'All Features', 'value': 'ALL', 'style': dropdown_options_style}
]


box_style={
            'width':'60%',
            'padding':'3px',
            'font-size': '20px',
            'text-align-last' : 'center' ,
            'margin': 'auto',  # Center-align the dropdown horizontally
            'background-color' : 'black',
            'color': 'black'
            }
# Create a dash application Cyborg







def layout():
    return html.Div(
    style={
        'color' : 'black',
        'backgroundColor': 'black',  # Set the background color of the app here
        'height': '100vh'  # Set the height of the app to fill the viewport
    },
    children=[
    html.Br(),
    html.Br(),
    html.Br(),
    html.H1('Nonequilibrium Langevin Dynamics Limit Cycle',
            style={'textAlign': 'center',
                   'color': 'white',
                   'background-color' : 'black',
                   'font-size': 40
                   }
            ),
    html.Br(),


    html.Br(),
    
    html.Hr(style={'border-color': 'white'}),
    html.Br(),

 
    html.Br(),
          # Create an outer division
     html.Div([ 
        html.Div([

        html.Div([
        html.H1("Enter the simulation parameters",
                style={'textAlign': 'center',
                            'color': 'grey',
                            'background-color' : 'black',
                            'font-size': 30
                            }
                ),
        html.Br(),
        html.Div([
            html.Label('Particule Numbers____: '),   
            dcc.Input(
                id='input-neld-nPart',
                type='number',
                value=2,  # Initial value
                debounce=True   
            ),
        ]),
        html.Div([
            html.Label('Box Deformation Rate: '),   
            dcc.Input(
                id='input-neld-epsilon',
                type='number',
                value=1,  # Initial value
                debounce=True  # Delay the callback until typing stops
            ),
        ]), 
    #############################
        html.Div([
            html.Label('Raduis Cut_____________: '),   
            dcc.Input(
                id='input-neld-rcut',
                type='number',
                value=30,  # Initial value
                debounce=True   
            ), 
        ]),  
    ############################
        html.Div([
            html.Label('Total Iterations Time__ : '),   
            dcc.Input(
                id='input-neld-N',
                type='number',
                value=50,  # Initial value
                debounce=True   
            ),
        ]),
        html.Div([
            html.Label('Total Period____________: '),   
            dcc.Input(
                id='input-neld-Nperiod',
                type='number',
                value=100,  # Initial value
                debounce=True  # Delay the callback until typing stops
            ), 
        ]), 

        
    ####################################################################################
    html.Br(), 
            dcc.Dropdown(
                id='dropdown-neld-flow',
                options=[
                        {'label': 'Zero Flow',                          'value': 'eld',     'style':  dropdown_options_style},
                        {'label': 'Shear Flow',                         'value': 'shear',   'style':  dropdown_options_style},
                        {'label': 'Planar Elongational Flow',           'value': 'pef',     'style':  dropdown_options_style},
                        ],
                value='',
                placeholder='Select the type of flow',
                style=box_style,
                searchable=True,
            ) ,

    ],
                style={'textAlign': 'center',
                            'color': 'white',
                            'background-color' : 'black',
                            'font-size': 20
                            }
                ),
html.Br(),
 html.Hr(style={'border-color': 'white'}),

            ############################################################################################################
 
                
    html.Div([
        html.Div(id='output-neld-fig', style={'display': 'inline-block'}),
        html.Div(id='output-neld-fig2', style={'display': 'inline-block'}),
    ],
    style={'textAlign': 'center',
                'color': 'white',
                'background-color' : 'black',
                'font-size': 20,
                # 'margin': 'auto',
                # 'width': '60%', 
                }
    ),

        ]),
     ]),
        html.Br(),
    html.Br(),
    html.Br(),
    html.Div([
        html.A(
            html.Img(src='https://img.icons8.com/color/48/000000/github.png'),
            href='https://github.com/aka-gera',
            target='_blank'
        ),
        html.A(
            html.Img(src='https://img.icons8.com/color/48/000000/linkedin.png'),
            href='https://www.linkedin.com/in/aka-gera/',
            target='_blank'
        ),
        html.A(
            html.Img(src='https://img.icons8.com/color/48/000000/youtube.png'),
            href='https://www.youtube.com/@aka-Gera',
            target='_blank'
        ),
    ], style={'display': 'flex', 'justify-content': 'center'})


])





app =  dash.Dash(__name__, external_stylesheets=[dbc.themes.DARKLY])
JupyterDash.infer_jupyter_proxy_config()

server = app.server
app.config.suppress_callback_exceptions = True

app.layout = layout()



@callback([ 
        Output('output-neld-fig', 'children'),
        Output('output-neld-fig2', 'children'),
    ],
    [
        Input('dropdown-neld-flow' , 'value'),
        Input('input-neld-nPart'   , 'value'),
        Input('input-neld-epsilon'    , 'value'), 
        Input('input-neld-rcut'    , 'value'),  
        Input('input-neld-N'       , 'value'),
        Input('input-neld-Nperiod' , 'value'), 
        ],
        prevent_initial_call=True
              )
def update_output(flow,nPart,epsilon,rcut,N,Nperiod): 

        # flow = 'eld'                     # choose the type of the flow (i.e 'eld', 'shear',  or 'pef')
        # nPart = 2                         # Number of particles
        # epsilon = 1.0                     # rate of the deformation of the background flow
        # rcut = 30                         # radius cut
        # N = 30                          # number of steps in a period
        # Nperiod = 100                   # number of periods
 

        pbc, param, _, X, sav = PBCs.Parameter(flow, epsilon, nPart, rcut, N, Nperiod)  # get the parameters
        Fun = myFun(param,pbc) 

        sav = Fun.Simulation(X, pbc,sav)
        datF = PBCs.paramFig(pbc['flow'],param['a'])

        bheight = 600
        bwidth = 600

        fig2 = dcc.Graph( figure = mygraph.plot_history_matrixxy(sav['Q1'],sav['Q2'],pbc['dt'],bheight,bwidth)) 
        fig = dcc.Graph(figure= mygraph.plot_history_matrixxy2(PBCs,sav,datF,param,pbc,bheight,bwidth))


        return  [fig2,fig]






# Run the app
if __name__ == '__main__':
    app.run_server(  debug=False)


