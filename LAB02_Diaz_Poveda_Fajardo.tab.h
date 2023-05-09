/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_LAB02_DIAZ_POVEDA_FAJARDO_TAB_H_INCLUDED
# define YY_YY_LAB02_DIAZ_POVEDA_FAJARDO_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TYPE = 258,                    /* TYPE  */
    MAIN = 259,                    /* MAIN  */
    IF = 260,                      /* IF  */
    ELSE = 261,                    /* ELSE  */
    WHILE = 262,                   /* WHILE  */
    FOR = 263,                     /* FOR  */
    DO = 264,                      /* DO  */
    SWITCH = 265,                  /* SWITCH  */
    CASE = 266,                    /* CASE  */
    DEFAULT = 267,                 /* DEFAULT  */
    INPUT = 268,                   /* INPUT  */
    OUTPUT = 269,                  /* OUTPUT  */
    INCLUDE = 270,                 /* INCLUDE  */
    ID = 271,                      /* ID  */
    POPEN = 272,                   /* POPEN  */
    PCLOSE = 273,                  /* PCLOSE  */
    SCOPE_START = 274,             /* SCOPE_START  */
    SCOPE_END = 275,               /* SCOPE_END  */
    COMMA = 276,                   /* COMMA  */
    COLON = 277,                   /* COLON  */
    SEMICOLON = 278,               /* SEMICOLON  */
    INT = 279,                     /* INT  */
    FLOAT = 280,                   /* FLOAT  */
    CHAR = 281,                    /* CHAR  */
    STRING = 282,                  /* STRING  */
    ASSIGNMENT = 283,              /* ASSIGNMENT  */
    HASH = 284,                    /* HASH  */
    HEADER_INCLUDE = 285,          /* HEADER_INCLUDE  */
    INCLUDE_LB = 286,              /* INCLUDE_LB  */
    OR = 287,                      /* OR  */
    AND = 288,                     /* AND  */
    EQUAL = 289,                   /* EQUAL  */
    NOT_EQUAL = 290,               /* NOT_EQUAL  */
    GREATER_THAN = 291,            /* GREATER_THAN  */
    GREATER_EQUAL = 292,           /* GREATER_EQUAL  */
    SMALLER_EQUAL = 293,           /* SMALLER_EQUAL  */
    SMALLER_THAN = 294,            /* SMALLER_THAN  */
    ADD = 295,                     /* ADD  */
    SUBSTRACT = 296,               /* SUBSTRACT  */
    MULTIPLY = 297,                /* MULTIPLY  */
    DIVIDE = 298,                  /* DIVIDE  */
    MODULO = 299,                  /* MODULO  */
    NOT = 300,                     /* NOT  */
    UMINUS = 301                   /* UMINUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_LAB02_DIAZ_POVEDA_FAJARDO_TAB_H_INCLUDED  */
