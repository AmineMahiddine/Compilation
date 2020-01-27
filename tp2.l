%option noyywrap
%{
  int someentier = 0;
  int nbr_int_c = 0;
  int nbr_ling = 0;
  int nbr_comm_line = 0;
  int start_line_comm = 0;
  int end_line_comm = 0;
  // int start_col_comm = 0;
  // int end_col_comm = 0;
  int line_counter = 0;

%}


espaceblanc [\ \t\n]

chifre [0-9]
integer [1-9][0-9]*|0
ident [a-zA-Z][a-zA-Z0-9_]* 
entierC {espaceblanc}*{ident}{espaceblanc}*[=]{espaceblanc}*{integer}{espaceblanc}*[,|;]
defEntierC [i][n][t]
chaine [a-z]*[A-Z]*
reel {chifre}*"."{chifre}
comment "//"[^/\n]*
%x comment foo


%%

 //   ----------------   les commantaire Methode 1 avec les Start Conditions ----------------
   int comment_caller;

\n ++line_counter;

"/*"         {
             comment_caller = INITIAL;
             BEGIN(comment);
             }

<foo>"/*"    {
             comment_caller = foo;
             BEGIN(comment);
             }

[/*]                    start_line_comm = line_counter;
<comment>[^*\n]*        /* eat anything that's not a '*' */ 
<comment>""+[^*/\n]   /* eat up '*'s not followed by '/'s */
<comment>\n             ++nbr_comm_line;
<comment>"*"+"/"        BEGIN(comment_caller);end_line_comm = line_counter;


do|while|if            printf("Reconue de : %s\n", yytext);

{entierC} {
  ++nbr_int_c;
  printf("Lu un entier en C\n");
}
{defEntierC}          printf("Declaration entier\n");


{chifre}+ {
  someentier+= atoi(yytext);
  printf("La somme des nombre est : %d\n", someentier);
}
{chaine}             printf("Reconue d'une chine de caractere = %s\n", yytext);


{reel} {
  float nbr_float = atof(yytext);
  printf("Reconue d'un nombre reel = %f\n", nbr_float);
}

{ident}  printf("Identificateur: %s\n",yytext);

"+"|"-"|"*"|"/"      printf( "operator c: %s\n", yytext );

{comment}         // ignorer les commantaire 


{espaceblanc}+   

.                   printf("Autre caractere: %s\n",yytext);



%%
// pas nececaire a cause de line 1 
//int yywrap(){} 

 int main(int argc, char** argv){

   yylex();

   if(argc > 1){
     yyin = fopen( argv[1], "r");
   }
   else {
     yyin = stdin;
   }

   printf("le nombre des entier lu est : %d\n",nbr_int_c);
   printf("la somme des entier lu est : %d\n",someentier);


   printf(" start ligne de commantaire est : %d\n",start_line_comm);
   printf(" nombre de  ligne de commantaire est : %d\n",nbr_comm_line );
   end_line_comm = nbr_comm_line - start_line_comm ;
   printf(" end ligne de commantaire est : %d\n",end_line_comm );
  //  printf(" start col de commantaire est : %d\n",start_col_comm);
  //  printf(" end col de commantaire est : %d\n",end_col_comm);
   printf(" nombre des ligne de programe : %d\n",line_counter);

 }
