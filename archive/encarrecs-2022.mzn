include "alldifferent.mzn";
include "globals.mzn";

% germans: 1 = Xavi, 2 = Quim, 3 = Jesús, 4 = Núria, 5 = Vicenç, 6 = Miqui, 7 = Joan Pau, 8 = Oriol
% encarrecs: 1 = WC0, 2 = WC1, 3 = Basures, 4 = Excrements, 5... resta

int: numGermans = 8;
int: numSetmanes = 60;
set of int: encarrecs = 1..8;
set of int: setmanes = 1..numSetmanes;
set of int: germans = 1..numGermans;

array[encarrecs, setmanes] of var 1..numGermans: assignacio;

% si s'afegeixen més restriccions es probable que sigui UNSAT (tarda molt). Amb chuffed solver troba la solució en 1s. Fer el problema amb minimitzar les diferencies a les assignacions tarda molt.

% tirar les basures ho fa tothom més o menys el mateix número de vegades i ben espaiat
constraint forall (k in germans) (
                  if (k != 4) then count_leq([ assignacio[3,j] | j in setmanes ], k, numSetmanes div 7) else true endif);
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 1) then true else assignacio[3,j] != assignacio[3,j+2] endif);
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 2) then true else assignacio[3,j] != assignacio[3,j+3] endif);   
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 3) then true else assignacio[3,j] != assignacio[3,j+4] endif);  
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 4) then true else assignacio[3,j] != assignacio[3,j+5] endif);                         

% els excrements ho fa tothom més o menys el mateix número de vegades i ben espaiat
constraint forall (k in germans) (
                  if (k != 4) then count_leq([ assignacio[4,j] | j in setmanes ], k, numSetmanes div 7) else true endif);
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 1) then true else assignacio[4,j] != assignacio[4,j+2] endif);
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 2) then true else assignacio[4,j] != assignacio[4,j+3] endif);   
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 3) then true else assignacio[4,j] != assignacio[4,j+4] endif);  
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 4) then true else assignacio[4,j] != assignacio[4,j+5] endif);

% encarrec 8 (ajudant) el mateix numero de vegades i ben espaiat
constraint forall (k in germans) (
                  count_leq([ assignacio[8,j] | j in setmanes ], k, numSetmanes div 8));
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 1) then true else assignacio[8,j] != assignacio[8,j+2] endif);
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 2) then true else assignacio[8,j] != assignacio[8,j+3] endif);   
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 3) then true else assignacio[8,j] != assignacio[8,j+4] endif);  
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 4) then true else assignacio[8,j] != assignacio[8,j+5] endif);
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 5) then true else assignacio[8,j] != assignacio[8,j+6] endif);
                  
% encarrec 7 el mateix numero de vegades i ben espaiat
constraint forall (k in germans) (
                  count_leq([ assignacio[7,j] | j in setmanes ], k, numSetmanes div 8));
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 1) then true else assignacio[7,j] != assignacio[7,j+2] endif);
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 2) then true else assignacio[7,j] != assignacio[7,j+3] endif);   
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 3) then true else assignacio[7,j] != assignacio[7,j+4] endif);  
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 4) then true else assignacio[7,j] != assignacio[7,j+5] endif);
constraint forall (j in setmanes) (
                  if (j >= numSetmanes - 5) then true else assignacio[7,j] != assignacio[7,j+6] endif);
             

constraint forall (j in setmanes) (
                  alldifferent( [ assignacio[i,j] | i in encarrecs ]));
                  
constraint forall (i in encarrecs, j in setmanes) (
                  if j == numSetmanes then true else assignacio[i,j] != assignacio[i,j+1] endif );

% La Núria no tira bassures ni excrements
constraint forall (j in setmanes) (
                  assignacio[3,j] != 4 );

constraint forall (j in setmanes) (
                  assignacio[4,j] != 4 );                                

% WC pis 0 el fa el Xavi, Quim o Jesús i es van tornant periòdicament
constraint forall (j in setmanes) (
                  if (j mod 3 == 1) then assignacio[1,j] == 1 else true endif);
constraint forall (j in setmanes) (
                  if (j mod 3 == 2) then assignacio[1,j] == 2 else true endif);
constraint forall (j in setmanes) (
                  if (j mod 3 == 0) then assignacio[1,j] == 3 else true endif);

% WC pis 1 el fa Nuria, Miqui, Joan Pau, Oriol i es van tornant periòdicament
constraint forall (j in setmanes) (
                  if (j mod 4 == 1) then assignacio[2,j] == 4 else true endif);
constraint forall (j in setmanes) (
                  if (j mod 4 == 2) then assignacio[2,j] == 6 else true endif);
constraint forall (j in setmanes) (
                  if (j mod 4 == 3) then assignacio[2,j] == 7 else true endif);
constraint forall (j in setmanes) (
                  if (j mod 4 == 0) then assignacio[2,j] == 8 else true endif);


solve satisfy;

output [ "\nSolucio\n\n" ];

output [ "\(assignacio[i,j])" ++ 
         if j == numSetmanes then "\n" else " " endif |
         i in encarrecs, j in setmanes
];
