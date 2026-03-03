#include "ex_lib1/ex_lib1.hpp"
#include "mbed.h"

// Initialise the digital pin LED1 as an output
#ifdef LED1
DigitalOut led(LED1);
#else
bool led;
#endif

int main()
{
    printf("--- reboot ---\n");
    printf("Build Time: " __DATE__ " " __TIME__ "\n");
    printf("MbedOS Version: %u.%u.%u\r\n", MBED_MAJOR_VERSION, MBED_MINOR_VERSION, MBED_PATCH_VERSION);
    while (true) {
        printf("[main]: Hello world from Mbed CE!\n");
        ex_lib1::example_function("hello from library");
        led = !led;
        ThisThread::sleep_for(1s);
    }

    // main() is expected to loop forever.
    // If main() actually returns the processor will halt
    return 0;
}
