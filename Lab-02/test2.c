#include <stdio.h>
#include <ctype.h>
#include <string.h>

typedef enum {
    TOKEN_INT, TOKEN_ID, TOKEN_NUM,
    TOKEN_ASSIGN, TOKEN_PLUS,
    TOKEN_SEMICOLON, TOKEN_UNKNOWN, TOKEN_EOF
} TokenType;

typedef struct {
    TokenType type;
    char lexeme[100];
} Token;

const char *src;
char current_char;

void next_char() {
    current_char = *src++;
}

void skip_whitespace() {
    while (isspace(current_char)) next_char();
}

Token next_token() {
    skip_whitespace();
    Token token;

    if (isalpha(current_char)) {
        int i = 0;
        while (isalnum(current_char)) {
            token.lexeme[i++] = current_char;
            next_char();
        }
        token.lexeme[i] = '\0';

        if (strcmp(token.lexeme, "int") == 0)
            token.type = TOKEN_INT;
        else
            token.type = TOKEN_ID;
        return token;
    }

    if (isdigit(current_char)) {
        int i = 0;
        while (isdigit(current_char)) {
            token.lexeme[i++] = current_char;
            next_char();
        }
        token.lexeme[i] = '\0';
        token.type = TOKEN_NUM;
        return token;
    }

    switch (current_char) {
        case '=': token.type = TOKEN_ASSIGN; token.lexeme[0] = '='; token.lexeme[1] = '\0'; next_char(); break;
        case '+': token.type = TOKEN_PLUS; token.lexeme[0] = '+'; token.lexeme[1] = '\0'; next_char(); break;
        case ';': token.type = TOKEN_SEMICOLON; token.lexeme[0] = ';'; token.lexeme[1] = '\0'; next_char(); break;
        case '\0': token.type = TOKEN_EOF; strcpy(token.lexeme, "EOF"); break;
        default: token.type = TOKEN_UNKNOWN; token.lexeme[0] = current_char; token.lexeme[1] = '\0'; next_char();
    }

    return token;
}

int main() {
    char input[] = "int x = 42 + y;";
    src = input;
    next_char();

    Token token;
    do {
        token = next_token();
        printf("Token: %-15s Type: %d\n", token.lexeme, token.type);
    } while (token.type != TOKEN_EOF);

    return 0;
}
