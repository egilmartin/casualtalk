def remove_outliers(start,stop,elist):
    '''(float,float,list)'''

    #WORKING
    # prepare elements list by removing any element not in interval of interest (start->stop). call this list ele2
    ele2 = elist
    #print(len(ele2))

    for i in xrange(len(ele2)-1,-1,-1):
        element = ele2[i]
        
        fields = element.split(',',3)

        estart = float(fields[0])

        estop= float(fields[3])


        if estop<start:
            del ele2[i]

        elif estart>stop:
            del ele2[i]

    #print(len(ele2))
        
    #print('first 10 elements are now {0}, last 10 elements are now {1}'.format(ele2[:10],ele2[10:]))
    return ele2


def make_box(etier,elabel,boxpos,boxdur,scale,rows,squares):


    picstart=str(int(boxpos*scale))
    
    piclength = str(int(boxdur*scale))
    #print('piclength is ',piclength)
                
    if elabel in squares:
        picol=squares[elabel]
    elif elabel == '{SL}': #SETS SPEAKER COLOUR FOR BACKGROUND
        picol = squares[etier]
    else: picol = squares['{SP}']
    rows[etier] = rows[etier] + '<img src={0}.png height=12 width={1} style="position:absolute;left:{2}">'.format(picol,piclength,picstart)
    return rows
    




def make_key(squares):
    keytable='<div style=position:fixed><table>'
    # NEED TO SORT SQUARES AS KEY IS COMING OUT IN WHATEVER ORDER DIC HAPPENS TO BE IN, LINES ARE COMING OUT IN ORDER SPECIFIED WHEN MAKING HTML TABLE ROWS 
    #for item in squares:
    for item in sorted(squares.keys()):
        keyrow = '<tr><td><img height=20 width=20 src={1}.png></td><td>{0}</td></tr>'.format(item,squares[item])
        keytable=keytable+keyrow

    keytable= keytable+'</table></div>'
    return keytable




def makeca(start,stop,interval,infile,outfile):
    ''' 
    (float,float,int,file,file)
    takes in table of start stop and label from praat and outputs html file with each participant's speech
    rendered in different colour blocks on a 'stave'
    '''

    
    elements =  [line.strip() for line in open(infile, 'r')]
    #print(elements[:4])
    
    outfile=open(outfile,'w')

    # colour box dictionary
    squares = {'{LG}':'yellow','{SP}':'dgreen','a':'lightgrad2','b':'lightgrad2','c':'lightgrad2','d':'lightgrad2','e':'lightgrad2'}




    
    # find number of blocks needed - rows of stave in final document
    num_blocks = (stop-start)//interval
    extra = (stop-start) % interval
    if extra>0:
        num_blocks = num_blocks + 1

    #print ('num blocks is {0} and extra is {1}'.format(num_blocks,extra))

    # define scale for drawing boxes
    scale = 800/float(interval)

    # define beginning and end of html page
    

    end_html = "</table></center></html>"

    mid_html=''



    
    # remove all elements outside interval (start -> stop)
    elements1= remove_outliers(start,stop,elements)

     # start list which will contain elements of interest only. this list will have newly created elements added to it and split elements removed from it.

    for i in range(1,num_blocks+1):
        dummy = '<img width="0" height="12" src="red.png">'

        # initialize what's in each row
        rows = {'a':dummy,'b':dummy,'c':dummy,'d':dummy,'e':dummy}
        elements2=[]
        elements2.extend(elements1)

        
        
        istart = float(start + interval*(i-1))
        istop = float(start + interval*i)
        if istop>stop:
            istop=stop

        # remove elements completely outside current interval
        elements3=remove_outliers(istart,istop,elements2)
        

        
        #print('in loop for numblocks. istart is {0}, istop is {1}'.format(istart,istop))
        



        for element in elements3:

            fields = element.split(',',3)
            estart = float(fields[0])
            etier = fields[1]
            elabel = fields[2]
            estop = float(fields[3])

            #print('===================================================================== element {0}, istart{1}, istop {2}'.format(element,istart,istop))

 
            #find textgrid intervals which start before html interval start and ends after html start.
            # create e1 which starts at istart and ends at estop if estop <= istop or ends at istop if estop>istop
            
            #draw box for e1
            if (estart <istart< estop): #if it starts before start of html interval and ends after start
                #print('starts before: estart is {0} which is less than {1} for {2}'.format(estart,istart,element))
                if estop <= istop:
                    e1='{0},{1},{2},{3}'.format(istart,etier,elabel,estop)
                    
                    boxstart=istart
                    boxstop=estop
                else:
                    e1='{0},{1},{2},{3}'.format(istart,etier,elabel,istop)
                    
                    boxstart=istart
                    boxstop=istop
                #print('++++++++++++++++++++++++++++++++++++++ADDING_A++++++++++++++++++++++++',edur)



                

            #find textgrid intervals which start at or after html interval start but before html stop
            # create e1 which starts at estart and ends at istop if estop >= istop, or ends at estop if estop<istop

            # draw box for e1
            elif (istart <= estart < istop):
                #print('ends after: estart is {0} which is greater than {1} for {2}'.format(estart,istart,element))
                if estop <= istop:
                    e1='{0},{1},{2},{3}'.format(estart,etier,elabel,estop)
                    
                    boxstart=estart
                    boxstop=estop
                else:
                    e1='{0},{1},{2},{3}'.format(estart, etier,elabel,istop)
                    
                    boxstart=estart
                    boxstop=istop
                #print('++++++++++++++++++++++++++++++++++++++ADDING_B+++++++++++++++++++++++++++',edur)
                    
            
            boxdur = boxstop-boxstart
            boxpos= boxstart-istart
            rows = make_box(etier,elabel,boxpos,boxdur,scale,rows,squares)                      
                



            

        

        rowstart = '<tr><td rowspan=2>{0}</td>'.format(str(start +(i-1)*interval))
        row = '<td ><div style=position:relative >{0}</div><div style=position:relative >{1}</div><div style=position:relative >{2}</div><div style=position:relative >{3}</div><div style=position:relative >{4}</div></td></tr><tr><td><br></td></tr>'.format(rows['a'],rows['b'],rows['c'],rows['d'],rows['e'])
        #print(row)
        
        mid_html = mid_html+rowstart+row
        

    keytable = make_key(squares)
    toprow='{0} seconds at {1} second intervals'.format(stop-start,interval)
    
    start_html = '<html><head><title>'+infile+'</title></head><body>'+infile+'<br>'+keytable+'<center><table border=1><tr><td></td><td width=800>'+toprow+'</td></tr>' #beginning of page and header row of table

    html1=start_html+mid_html+end_html
    #print(html1)
    

    outfile.write(html1)


    outfile.close()


            
    
    
