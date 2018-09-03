%{
#include<stdio.h>
#include<math.h>
#include<string.h>
#include <ctype.h>
#include<sys/wait.h>
#include <dirent.h>
#include "cali.tab.h"
int yywrap(void);
void pars(char *);
FILE *fp;
%}


%%

\<img[ \r]?src=\"[^\>]*\>[ \n\t\r\\n]* {
					return STAG;
					}
					
\<\/em\>[ \n\t\r\\n]*Contact    {
				return STAG;
				}
          	 
\<i[ \r]?class\=\"fa[ \r]?fa\-phone\"\>[ \n\t\r\\n]*\<\/i\>     {
								 return DESG;
								 }
						
\<p[ \r]?style=\"[^\<]*[\<]?[^\<]*[\<]?[^\<]*\<span\>	{
						return DESG;
						}
						
[ \n\t\r\\n]*Website[ \n\t\r\\n]*\<\/a\>        {
						return WEB;
						}
						
\<\/em\>[ \n\t\r\\n]*Awards[ \r]?and[ \r]?Accolades	{
							return AWARD;
							}

\<\/em\>[ \n\t\r\\n]*Responsibilities    {
			 		 return RES;
					 }

			
\<[^\/][a-zA-Z0-9\"\'\?\/:;\._\@\=\#\-\~\% \n\t\r]*\>[ \n\t\r\\n]*  {
								strcpy(yylval.lal,yytext);
								return TAG;
								}
	
[a-zA-Z0-9:\& ;(),\+\.\@\t\r\-\/]+       {
					strcpy(yylval.lal,yytext);
					return CHAR;
					}

[ \n\t\r\\n]*\<\/[a-zA-Z0-9]+\>[ \n\t\r\\n]*    {
						strcpy(yylval.lal,yytext);
						return CTAG;
						}
	
\<\/i\>[ \n\t\r\\n]*Group[ \r]?Members  {
					return GROUP;
					}
					
\<p[^\>]*\>[ \n\t\r\\n]*\<span[^\>]*\>  {
					return PROJ;
					}
					
[ \n\t\r\\n]*\<\/p\>[ \n\t\r\\n]*\<\/div\>[ \n\t\r]*  {
					return PEND;
					}
					
\<footer\>\<div[^\>]\>  {
			return FOOT;
			}
			
[ \n\t\r\\n]*\<i\>[ \n\t\r\\n]*by[ \n\t\r\\n]*\<\/i\>	{
							return BY;
							}
				
[ \n\t\r\\n]*\<b\>[0-9a-zA-Z:,\.\-() \n]*\<\/b\>	{
							strcpy(yylval.lal,yytext);
							return YEAR;
							}
				
[ \n\t\r]*\<u\>[ \n\t\r]*\<b\>[0-9a-zA-Z:,\.\-() \n]*\<\/b\>	{
								strcpy(yylval.lal,yytext);
								return PROG;
								}
								
[ \n\t\r]*\<div[^\>]*\>[ \n\t\r]*\<\/div\> 	{
						return DIV;
						}
		
\n ;
[ \n\t\r]*&nbsp ;
. ;


%%

int yywrap(){
	printf("End of parsing\n");
}

void yyerror(const char *str)
{
	printf(" Invalid Character...");
}

char* trimwhitespace(char *str)
{
	while(isspace(*str) || (*str==';')) str++;
	if(*str == 0) 
		return NULL;
	return str;
}

char *rmspace(char *str)
{
	char *temp;
	char store[1000];
	int len=0;
	while(temp=strstr(str,"&nbsp;")){
		strncpy(store+len,str,strlen(str)-strlen(temp));
		strncpy(store+strlen(str)-strlen(temp),"\0",1);
		str=temp+6; len = strlen(store);
	}
	strcat(store,str);
	str = store;
	return str;
}

int main()
{
	struct dirent *dp;
	DIR *dfd;
	char cwd[1024];
	chdir("./page");
	getcwd(cwd, sizeof(cwd));
	if ((dfd = opendir(cwd)) == NULL)
	{
		printf("Can't open directory\n");
		return 0;
	}
	while ((dp=readdir(dfd)) != NULL) {
		if(strcmp(dp->d_name,"..") && strcmp(dp->d_name,"."))
			pars(dp->d_name);
	}
	closedir(dfd);
	return(0);
}

void pars(char *str)
{
	FILE *fh;
	if (fh = fopen(str, "r"))   
	{
		yyin = fh;
		do {
		yyparse();
	} while (!feof(yyin));}
}
