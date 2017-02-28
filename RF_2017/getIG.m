
function ig = getIG(data,idx) % Information Gain - the 'purity' of data labels in both child nodes after split. The higher the purer.
data=  data(:,end);
L = data(idx);
R = data(~idx);

H = getE(data);


HL = getE(L);
HR = getE(R);
ig = H - sum(idx)/length(idx)*HL - sum(~idx)/length(idx)*HR;

end