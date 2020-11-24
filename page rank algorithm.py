a=[]
p=[]
n1=[]
n2=[]
d=float(input("Enter value of d:"))
n=int(input("Enter number of nodes:"))
for i in range(0,n):
    a.append([])
    p.append(1.0)
    for j in range(0,n):
        b=int(input("Press 1 if edge exists else 0:"))
        a[i].append(b)
print("Adjacency matrix " , end ="")       
print(a)  
 for i in range(0,n):
   n1.append(0)
   n2.append([])
   for j in range(0,n):
        if(a[i][j]==1):
            n1[i]+=1     
        if(a[j][i]==1):
            n2[i].append(j)
#print(n1)   #outgoing nodes
#print(n2)   #incoming nodes
print("Iteration 0:",end =" ")          
print(p)    #pagerank matrix
for i in range(0,3):
    for j in range(0,n):
          v=0.0
          for k in range(0,len(n2[j])):
                k1=n2[j][k]             #second half of formula
                v+=p[k1]/n1[k1]
          p[j]=(1-d)+d*v
    print("Iteration %d:" %(i+1),end =" ")
    print(p)        
