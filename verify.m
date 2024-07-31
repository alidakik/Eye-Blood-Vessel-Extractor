function [sensitivity,specificity,accuracy] = verify(manual, generated)


TP = sum((manual == 1) & (generated == 1));
TN = sum((manual == 0) & (generated == 0));
FP = sum((manual == 0) & (generated == 1));
FN = sum((manual == 1) & (generated == 0));



sensitivity = TP / (TP + FN)
specificity = TN / (TN + FP)
accuracy = (TP + TN) / (TP + TN + FP + FN)



end