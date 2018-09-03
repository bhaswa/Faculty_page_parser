%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <ctype.h>

int yylex(void);
void yyerror(const char *s);
char *trimwhitespace(char *str);
char *rmspace(char *str);
int yydebug=5;
FILE *fp;
char output[1000],name[100],final[1000],award[4],proj[1000],progrm[10],res[10000],addr[100];
int yr=0,cnt=0,awd,pub=0,rp=0,ad=0,enter=0;

%}

%union
{

 char lal[10000];
}

%token <lal> CHAR
%token <lal> STAG CTAG TAG RES AWARD DESG WEB PROJ GROUP FOOT PEND BY YEAR PROG DIV
%type <lal> exp
%type <lal> A C D E F G H P M

%%

state : exp 	{printf("parsing done\n");
		char store[1000];
		if(cnt==5){
			strcpy(final,output);
			if(ad!=0){
				strcat(final,addr);
				strcat(final,"\t");
			}
			else{
				strcat(final,"NILL");
				strcat(final,"\t");
			}
		}
		else{
			char *temp;
			temp = strtok(output,"\t");
			strcpy(final,temp);
			strcat(final,"\t");
			temp = strtok(NULL,"\t");
			strcat(final,temp);
			strcat(final,"\t");
			strcat(final,"NILL");
			strcat(final,"\t");
			if(cnt==4){
				for(int i=0;i<2;i++){
					temp = strtok(NULL,"\t");
					strcat(final,temp);
					strcat(final,"\t");
			
				}
			}
			else{
				temp = strtok(NULL,"\t");
				strcat(final,temp);
				strcat(final,"\t");
				strcat(final,"NILL");
				strcat(final,"\t");
			}
			if(ad!=0){
				strcat(final,addr);
				strcat(final,"\t");
			
			}
			else{
				strcat(final,"NILL");
				strcat(final,"\t");
			}
		}
		fp=fopen("../out.csv","a");
		strcpy(store,rmspace(final));
		fprintf(fp,"%s",store);
		if(rp!=0)
			fprintf(fp,"%s",res);
		else
			fprintf(fp,"NILL");
		fprintf(fp,"\n");
		fflush(fp);
		fclose(fp);
		bzero(output,1000);
		bzero(final,1000);
		bzero(name,100);
		bzero(res,10000);
		bzero(addr,100);
		cnt = 0;enter=0;rp=0;ad=0;
		}
;
 
exp :    exp STAG E A CTAG{cnt++;}
	|exp AWARD E C CTAG
	|exp RES E A CTAG {cnt++;}
	|exp DESG A CTAG {cnt++;}
	|exp CHAR
	|CHAR
	|exp CTAG
	|CTAG
	|exp TAG
	|exp GROUP P FOOT
	|TAG
	|PEND
	|exp PEND
	|exp DIV
	|exp TAG WEB    {
			ad=1;
			char *token,*temp;
			token = strtok($2,"\"");
			token = strtok(NULL,"\"");
			token = strtok(NULL,"\"");
			token = strtok(NULL,"\"");
			temp = strstr(token,"jsessionid");
			if(temp)
				*temp = '\0';
			strcpy(addr,token);
			}
;

E :	 E CTAG
	|CTAG
	|TAG
	|E TAG
;

A : CHAR {
	if(strcmp(trimwhitespace($1),"&nbsp")){
		char *temp = strstr($1,"&amp");
		if(temp)
			*(temp+4) = ' ';
		strcat(output,trimwhitespace($1));
		strcat(output,"\t");
		if(cnt==0)
			strcpy(name,trimwhitespace($1));
	}
	}
       | A CHAR{
        if(strcmp(trimwhitespace($2),"&nbsp")){
		char *temp = strstr($2,"&amp");
		if(temp)
			*(temp+4) = ' ';
		strcat(output,trimwhitespace($2));
		strcat(output,"\t");
		if(cnt==0)
			strcpy(name,trimwhitespace($2));
	}
       }
;


C : C CHAR CTAG TAG{
		if(*(trimwhitespace($2)+strlen(trimwhitespace($2))-1)==')')
			strncpy(award,trimwhitespace($2)+strlen(trimwhitespace($2))-5,4);
		else
   			strncpy(award,trimwhitespace($2)+strlen(trimwhitespace($2))-4,4);
   		awd=0;
   		for(int i=0;i<3;i++){
   			if(!(isdigit(award[i]))){
   				awd=1;
   				break;
   				}
   		}
	       fp=fopen("../Awards.csv","a");
	       if(awd==0){
	       		if(*(trimwhitespace($2)+strlen(trimwhitespace($2))-1)==')')
	       			*(trimwhitespace($2)+strlen(trimwhitespace($2))-6)='\0';
	       		else
	       			*(trimwhitespace($2)+strlen(trimwhitespace($2))-6)='\0';
	       		fprintf(fp,"%s\t%s\t%s\n",name,trimwhitespace($2),award);
	       	}
	       	else
	       		fprintf(fp,"%s\t%s\t\n",name,trimwhitespace($2));
	       fflush(fp);
	       fclose(fp);
	       }
	|CHAR CTAG TAG{
   		if(*(trimwhitespace($1)+strlen(trimwhitespace($1))-1)==')')
			strncpy(award,trimwhitespace($1)+strlen(trimwhitespace($1))-5,4);
		else
   			strncpy(award,trimwhitespace($1),4);
   		awd=0;
   		for(int i=0;i<3;i++){
   			if(!(isdigit(award[i]))){
   				awd=1;
   				break;
   				}
   		}
	       fp=fopen("../Awards.csv","a");
	       if(awd==0){
	       		if(*(trimwhitespace($1)+strlen(trimwhitespace($1))-1)==')')
	       			*(trimwhitespace($1)+strlen(trimwhitespace($1))-6)='\0';
	       		else
	       			*(trimwhitespace($1)+strlen(trimwhitespace($1))-5)='\0';
	       		fprintf(fp,"%s\t%s\t%s\n",name,trimwhitespace($1),award);
	       	}
	       	else
	       		fprintf(fp,"%s\t%s\t\n",name,trimwhitespace($1));
	       fflush(fp);
	       fclose(fp);
	       }
	|CHAR CTAG CTAG{
   		if(*(trimwhitespace($1)+strlen(trimwhitespace($1))-1)==')')
			strncpy(award,trimwhitespace($1)+strlen(trimwhitespace($1))-5,4);
		else
   			strncpy(award,trimwhitespace($1),4);
   		awd=0;
   		for(int i=0;i<3;i++){
   			if(!(isdigit(award[i]))){
   				awd=1;
   				break;
   				}
   		}
	       fp=fopen("../Awards.csv","a");
	       if(awd==0){
	       		if(*(trimwhitespace($1)+strlen(trimwhitespace($1))-1)==')')
	       			*(trimwhitespace($1)+strlen(trimwhitespace($1))-6)='\0';
	       		else
	       			*(trimwhitespace($1)+strlen(trimwhitespace($1))-5)='\0';
	       		fprintf(fp,"%s\t%s\t%s\n",name,trimwhitespace($1),award);
	       	}
	       	else
	       		fprintf(fp,"%s\t%s\t\n",name,trimwhitespace($1));
	       fflush(fp);
	       fclose(fp);
	       }
	|C CHAR CTAG CTAG{
   		if(*(trimwhitespace($2)+strlen(trimwhitespace($2))-1)==')')
			strncpy(award,trimwhitespace($2)+strlen(trimwhitespace($2))-5,4);
		else
   			strncpy(award,trimwhitespace($2)+strlen(trimwhitespace($2))-4,4);
   		awd=0;
   		for(int i=0;i<3;i++){
   			if(!(isdigit(award[i]))){
   				awd=1;
   				break;
   				}
   		}
	       fp=fopen("../Awards.csv","a");
	       if(awd==0){
	       		if(*(trimwhitespace($2)+strlen(trimwhitespace($2))-1)==')')
	       			*(trimwhitespace($2)+strlen(trimwhitespace($2))-6)='\0';
	       		else
	       			*(trimwhitespace($2)+strlen(trimwhitespace($2))-5)='\0';
	       		fprintf(fp,"%s\t%s\t%s\n",name,trimwhitespace($2),award);
	       	}
	       	else
	       		fprintf(fp,"%s\t%s\t\n",name,trimwhitespace($2));
	       fflush(fp);
	       fclose(fp);
	       }
;

P : 	P TAG
	|CTAG
	|P CTAG
	|P CHAR
	|P GROUP D FOOT
;

D : 	D TAG
       |D CTAG
       |CTAG
       |D PROJ F PEND G PEND H PEND M PEND
       |D PROJ F PEND DIV H PEND M PEND
       |D PROJ F PEND G PEND DIV M PEND
       |D PROJ F PEND G PEND H PEND DIV
       |D PROJ F PEND G PEND DIV DIV
       |D PROJ F PEND DIV DIV M PEND
       |D PROJ F PEND DIV H PEND DIV
       |D PROJ F PEND DIV DIV DIV
;

F : 	CHAR {
		if(trimwhitespace($1)!=NULL)
			strcat(res,trimwhitespace($1));
		rp=1;
		}
	|F CHAR{
		if(trimwhitespace($2)!=NULL)
			strcat(res,trimwhitespace($2));
		rp=1;
		}
	|F TAG 
	|F CTAG
	|CTAG
	|F DIV
;

G : 	TAG
	|G TAG
	|G PROJ{
		enter=1;
		fp=fopen("../Publication.csv","a");
		fprintf(fp,"%s\t",name);
		fflush(fp);
		fclose(fp);
		}
	|G CTAG
	|CHAR
	|G CHAR {
		if(enter!=0 && pub<3){	
			fp=fopen("../Publication.csv","a");
			if(trimwhitespace($2)!=NULL)
				fprintf(fp,"%s\t",trimwhitespace($2));
			fflush(fp);
			fclose(fp);
		}
		pub++;
		}
	|G BY
	|G YEAR CHAR	{
			fp=fopen("../Publication.csv","a");
			*(trimwhitespace($3)+strlen(trimwhitespace($3))-1)='\0';
			fprintf(fp,"%s\n",trimwhitespace($3)+1);
			fflush(fp);
			fclose(fp);
			pub=0;
			}
;

H : 	TAG
	|H TAG
	|H PROJ{
		fp=fopen("../Project.csv","a");
		fprintf(fp,"%s\t",name);
		fflush(fp);
		fclose(fp);
		}
	|H CTAG
	|CHAR
	|H CHAR {
		char *temp;
		temp = strstr($2,"&nbsp");
		if(temp)
			*temp = '\0';
		temp = strstr($2,"&amp");
		if(temp)
			*temp = '&';
		strcat(proj,$2);
		}
	|H YEAR  {
		char *token;
		fp=fopen("../Project.csv","a");
		token = strtok(trimwhitespace($2),">");
		token = strtok(NULL,"<");
		fprintf(fp,"%s\t%s\n",proj,token);
		fflush(fp);
		fclose(fp);
		bzero(proj,1000);
		}
;

M :	CHAR
	|M CHAR
	|M TAG
	|TAG
	|M CTAG
	|M PROJ CTAG CHAR{
		fp=fopen("../Group.csv","a");
		fprintf(fp,"%s\t%s\t%s\t",name,progrm,trimwhitespace($4));
		fflush(fp);
		fclose(fp);
		}
	|M PROG {
		char *token;
		token = strtok(trimwhitespace($2),"<");
		token = strtok(NULL,"<");
		token = strtok(token,">");
		token = strtok(NULL,">");
		bzero(progrm,10);
		strcpy(progrm,token);
		}
	|M YEAR TAG CHAR {
			fp=fopen("../Group.csv","a");
			fprintf(fp,"%s\n",trimwhitespace($4));
			fflush(fp);
			fclose(fp);
			}
	|M YEAR TAG CTAG {
			fp=fopen("../Group.csv","a");
			fprintf(fp,"\t\n");
			fflush(fp);
			fclose(fp);
			}
;
%%

