#include "mbed.h"

// Initialise the digital pin LED1 as an output
#ifdef LED1
DigitalOut led(LED1);
#else
bool led;
#endif

int main()
{
    while (true)
    {
        printf("Hello world from Mbed CE!\n");
        led = !led;
        ThisThread::sleep_for(1s);
    }

    // main() is expected to loop forever.
    // If main() actually returns the processor will halt
    return 0;
}
