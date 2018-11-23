function a_ag= TreeTrans(a,cesi,range)


% a=[2 3 5 3;1 2 3 1];
% cesi=0.8;
% range=1;

[hei, wid] = size(a);
a_ag=zeros(hei, wid);
for i=1:hei
    for j=1:wid
        weight=0;
        if (j-range)<=0
            start=1;
        else
            start=j-range;
        end
        if (j+range)>wid
            ended=wid;
        else
            ended=j+range;
        end
        for p=start:ended
            if j>=p
                a_ag(i,j)= a_ag(i,j)+(cesi^(j-p))*a(i,p);
                weight=weight+cesi^(j-p);
            else
                a_ag(i,j)= a_ag(i,j)+(cesi^(p-j))*a(i,p);
                weight=weight+cesi^(p-j);
            end
        end
        a_ag(i,j)=a_ag(i,j)/weight;
    end
end
end




