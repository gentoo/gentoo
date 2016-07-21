/**
 * Use "gcc -Werror -Wl,-l:libobjc.so.x testlibobjc.m -o /dev/null" 
 * #import generates a warning with non-objc
 */
#import <stdio.h>

int main( int argc, const char *argv[] ) {
    printf("Linker test\n");
    return 0;
}
