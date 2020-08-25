def makeca(infile,outfile):
    ''' takes in ca script generated from praat and outputs html file with each participant's speech rendered in a different colour
    '''

    infile1 = open(infile)
    outfile=open(outfile,'w')


    line = infile1.readline()
    outfile.write(line)
    coltext = {'jens':'<span style="color:#000000">','catha':'<span style="color:#B404AE">','nick':'<span style="color:#0040FF">','nike':'<span style="color:#088A08">','fred':'<span style="color:#FF0000">'}
    colwrite = '<span style="color:#000000">'
    
    





    for line in infile1:
        # line = infile1.readline()
        line = line.rstrip('\n')
        fields = line.split('\t')
##        print('fields are ',fields)
        
        if ((line != '') and (fields[1] !='')):
##            print('in loop. speaker is     ',fields[1])
            speaker = str(fields[1])
            speaker =  speaker.rstrip(':')
            colwrite = coltext[speaker]
            
        line = '<p> ' + colwrite + line + '</p>' +'\n'
##        print('line is now    ',line)
##        print('line is now  ' + line)
                        
        outfile.write(line)

        


    outfile.close()

    infile1.close()

            
    
    
