import  pandas as pd
def pci(data):
	classes=[0,0]
	for i in range(len(data)):
		if(data.iloc[i,-1]=='Yes'):
			classes[0]+=1
		else:
			classes[1]+=1
	return classes[0],classes[1]
def pcix(data,X,c1,c2):
	count_yes=[0 for i in range(len(data.columns))]
	count_no=[0 for i in range(len(data.columns))]
	p1=1
	p2=1
	for i in range(len(data)):
		if(data.iloc[i,0]==X[0]):
			if(data.iloc[i,-1]=='Yes'):
				count_yes[0]+=1
			else:
				count_no[0]+=1
		if(data.iloc[i,1]==X[1]):
			if(data.iloc[i,-1]=='Yes'):
				count_yes[1]+=1
			else:
				count_no[1]+=1
		if(data.iloc[i,2]==X[2]):
			if(data.iloc[i,-1]=='Yes'):
				count_yes[2]+=1
			else:
				count_no[2]+=1
		if(data.iloc[i,3]==X[3]):
			if(data.iloc[i,-1]=='Yes'):
				count_yes[3]+=1
			else:
				count_no[3]+=1
	for i in range(len(count_no)-1):
		p1=p1*count_yes[i]/c1
		p2=p2*count_no[i]/c2
	return p1,p2
dataset=pd.read_csv('DataSet.csv')
data=dataset.iloc[:,1:]
in1=input("Enter the tuple values(age, income, student, credit rating):")
X=in1.split(',')
c1,c2=pci(data)
p1,p2=pcix(data,X,c1,c2)
print(c1,c2,p1,p2)
print((p1*c1)/len(data))
print(p2*c2/len(data))
if(p1*c1>p2*c2):
	print("Buys")
else:
	print("Doesn't buy")
