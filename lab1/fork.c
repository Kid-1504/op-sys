#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "factorial.h"

#define MAXBUFSIZE 1024
const int STDOUT = 1;

int n = 11;

int main() {
    char buffer[MAXBUFSIZE];
    int pipefd[2];
    pipe(pipefd);
    ssize_t pid = fork();
    if (pid == 0) { // дочерний процесс
        long long int factorial_value = factorial(n);
        ssize_t len = snprintf(buffer, sizeof(buffer), "Factorial of %d is %lld\n", n, factorial_value);
        close(pipefd[0]);
        write(pipefd[1], buffer, len); // Изменено на len вместо MAXBUFSIZE
        close(pipefd[1]);
        _exit(0);
    } 
    else if (pid > 0) { // родительский процесс
        int status;
        close(pipefd[1]);
        wait(&status);
        ssize_t len = read(pipefd[0], buffer, MAXBUFSIZE);
        write(STDOUT, buffer, len);
        close(pipefd[0]);
    } 
    else { // ошибка
        printf("Error creating a child process!\n");
    }
    return 0;
}
