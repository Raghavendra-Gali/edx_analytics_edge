## Load in the csv file for the competition, add pricing data

import csv


def processData(inputFileName, outputFileName):
    # Wifi prices
    iPadWifi = dict()

    ##                                16     32     64    128  Unkown      
    #iPadWifi['iPad 1']           = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadWifi['iPad 2']           = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadWifi['iPad 3']           = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadWifi['iPad 4']           = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadWifi['iPad 5']           = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadWifi['iPad Air']         = ['399','499',  'NA',  'NA',  'NA']
    #iPadWifi['iPad Air 2']       = ['499', 'NA', '599', '699',  'NA']
    #iPadWifi['iPad mini']        = ['209', 'NA',  'NA',  'NA',  'NA']
    #iPadWifi['iPad mini 2']      = ['299','349',  'NA',  'NA',  'NA']
    #iPadWifi['iPad mini 3']      = ['399', 'NA', '499', '599',  'NA']
    #iPadWifi['iPad mini Retina'] = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadWifi['Unknown']          = ['NA',  'NA',  'NA',  'NA',  'NA']
    #
    ## Wifi prices
    #iPadCell = dict()
    ##                                16     32     64    128   Unkown
    #iPadCell['iPad 1']           = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadCell['iPad 2']           = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadCell['iPad 3']           = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadCell['iPad 4']           = ['NA', '449', '499', '589',  'NA']
    #iPadCell['iPad 5']           = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadCell['iPad Air']         = ['529','579',  'NA',  'NA',  'NA']
    #iPadCell['iPad Air 2']       = ['629', 'NA', '729', '829',  'NA']
    #iPadCell['iPad mini']        = ['309','359', '409',  'NA',  'NA']
    #iPadCell['iPad mini 2']      = ['429','479',  'NA',  'NA',  'NA']
    #iPadCell['iPad mini 3']      = ['529', 'NA', '629', '729',  'NA']
    #iPadCell['iPad mini Retina'] = ['NA',  'NA',  'NA',  'NA',  'NA']
    #iPadCell['Unknown']          = ['NA',  'NA',  'NA',  'NA',  'NA']

# Imputed some values here myself .. 
    #                                16     32     64    128  Unkown      
    iPadWifi['iPad 1']           = ['149', '199',  '249',  '299',  'NA']
    iPadWifi['iPad 2']           = ['199', '249',  '299',  '349',  'NA']
    iPadWifi['iPad 3']           = ['249', '299',  '349',  '399',  'NA']
    iPadWifi['iPad 4']           = ['299', '349',  '399',  '449',  'NA']
    iPadWifi['iPad 5']           = iPadWifi['iPad 4']
    iPadWifi['iPad Air']         = ['399', '499',  '599',  '699',  'NA']
    iPadWifi['iPad Air 2']       = ['499', '549',  '599',  '699',  'NA']
    iPadWifi['iPad mini']        = ['209', '249',  '299',  '349',  'NA']
    iPadWifi['iPad mini 2']      = ['299', '349',  '399',  '449',  'NA']
    iPadWifi['iPad mini 3']      = ['399', '449',  '499',  '599',  'NA']
    iPadWifi['iPad mini Retina'] = iPadWifi['iPad mini 2']
    iPadWifi['Unknown']          = ['299', '349',  '399',  '449',  'NA']
    
    iPadCell = dict()
    #                                16     32     64    128   Unkown
    iPadCell['iPad 1']           = ['279',  '329',  '379',  '429',  'NA']
    iPadCell['iPad 2']           = ['329',  '379',  '429',  '479',  'NA']
    iPadCell['iPad 3']           = ['379',  '429',  '479',  '529',  'NA']
    iPadCell['iPad 4']           = ['429',  '479',  '529',  '589',  'NA']
    iPadCell['iPad 5']           = iPadCell['iPad 4']
    iPadCell['iPad Air']         = ['529',  '579',  '629',  '679',  'NA']
    iPadCell['iPad Air 2']       = ['629',  '659',  '729', ' 829',  'NA']
    iPadCell['iPad mini']        = ['309',  '359',  '409',  '459',  'NA']
    iPadCell['iPad mini 2']      = ['429',  '479',  '529',  '579',  'NA']
    iPadCell['iPad mini 3']      = ['529',  '579',  '629',  '729',  'NA']
    iPadCell['iPad mini Retina'] = iPadWifi['iPad mini 2']
    iPadCell['Unknown']          = ['429',  '479',  '529',  '579',  'NA']




    iPads = dict()
    iPads['0'] = iPadWifi
    iPads['1'] = iPadCell
    
    
    lineCount = 0
    storageIndex = -1
    cellIndex = -1
    modelIndex = -1
    storageLabel = 'storage'
    cellLabel = 'cellular'
    modelLabel = 'productline'
    
    
    
    with open(inputFileName, 'rU') as inputCSVFile:
        fileReader = csv.reader(inputCSVFile, delimiter=',')

        with open(outputFileName, 'w') as outputCSVFile:
            fileWriter = csv.writer(outputCSVFile, delimiter=',')
        
            for row in fileReader:
                lineCount += 1
                #print 'Line ' + str(lineCount)
                
                if (lineCount == 1):
                    print 'Found column names'
                    colNames = row
                    for index, name in enumerate(colNames):
                        if (name == storageLabel):
                            storageIndex = index
                            print ' -> Found storage at index ' + str(storageIndex)
                        elif (name == cellLabel):
                            cellIndex = index
                            print ' -> Found cellular at index ' + str(cellIndex)
                        elif (name == modelLabel):
                            modelIndex = index
                            print ' -> Found model at index ' + str(modelIndex)
                            
                    
                    row.append('retailprice')
                
                else:
                    currentStorage = row[storageIndex]
                    currentCellular = row[cellIndex]
                    currentModel = row[modelIndex]

                    if (currentStorage == '16'):
                        storageValueIndex = 0
                    elif (currentStorage == '32'):
                        storageValueIndex = 1
                    elif (currentStorage == '64'):
                        storageValueIndex = 2
                    elif (currentStorage == '128'):
                        storageValueIndex = 3
                    elif (currentStorage == 'Unknown'):
                        storageValueIndex = 4

                    if (currentCellular == "Unknown"):
                        price = iPads['0'][currentModel][storageValueIndex]
                    else:
                        price = iPads[currentCellular][currentModel][storageValueIndex]
                        
                        print 'Model = ' + str(currentModel) + \
                            ', Cell = '    + str(currentCellular) + \
                            ', Storage = ' + str(currentStorage)  + \
                            ', Price = '  + str(price)
                
                    row.append(price)
                
                fileWriter.writerow(row)
                        
#                print ', '.join(row)
            

processData('eBayiPadTrain.csv', 'eBayiPadTrainPrices.csv')
processData('eBayiPadTest.csv', 'eBayiPadTestPrices.csv')

