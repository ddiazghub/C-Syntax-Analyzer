bison -d LAB02_Diaz_Poveda_Fajardo.y
lex -o LAB02_Diaz_Poveda_Fajardo.c LAB02_Diaz_Poveda_Fajardo.l
gcc LAB02_Diaz_Poveda_Fajardo.c LAB02_Diaz_Poveda_Fajardo.tab.c -ll -o LAB02_Diaz_Poveda_Fajardo