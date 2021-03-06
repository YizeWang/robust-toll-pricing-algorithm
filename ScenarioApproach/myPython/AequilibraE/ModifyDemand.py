import os
import time
import shutil
import numpy as np
from os.path import join
from aequilibrae.matrix import AequilibraeMatrix


pathFolder = '/home/onion/SiouxFalls'
nameProject = 'SiouxFalls.sqlite'

dmndFolder = join(pathFolder, '0_tntp_data')
projFolder = join(pathFolder, '1_project')
AssgFolder = join(pathFolder, '4_assignment_results')

if os.path.exists(join(dmndFolder, 'demand.omx')): os.remove(join(dmndFolder, 'demand.omx'))
shutil.copy2(join(dmndFolder, 'demand backup.omx'), join(dmndFolder, 'demand.omx'))

demand = AequilibraeMatrix()
demand.load(join(dmndFolder, 'demand.omx'))
demand.computational_view(['matrix'])
baseDemand = demand.matrix_view

numSample = 1
randRange = 0.0

for s in range(numSample):
    randCoeff = (np.random.rand(baseDemand.shape[0], baseDemand.shape[1]) - 0.5) * 2 * randRange + 1
    randDemand = np.multiply(randCoeff, baseDemand)
    nameMatrix = 'Demand' + str(s)
    demand.matrix_view = randDemand
    demand.save([nameMatrix])

demand.close()
