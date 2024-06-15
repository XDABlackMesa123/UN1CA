---
layout: default
title: Install UN1CA
parent: Installation instructions
nav_order: 2
---

# Install UN1CA
{: .pb-2 }

{: .warning }
> Installing UN1CA for the first time **REQUIRES** a full data wipe (this is NOT counting the data wipe when unlocking the bootloader nor rooting your device).
> Please make a backup of your data before proceeding.

<p align="center">
  <img loading="lazy" src="/assets/images/twrp.png" width="30%"/>
</p>

Installing custom ROMs via a recovery has been the standard since Android early times, and today it's still the way to go in most devices.
This guide will not go in deep details about how to install a custom recovery, as the procedure might differ from device to device, so please refer to the XDA community page for [your device]({% link devices/index.md %}).

To install UN1CA, a custom recovery and/or other unofficial images, your device's bootloader **must be unlocked**. If you are unsure please take a look at the ["Unlocking the bootloader"]({% link guide/bootloader.md %}) page.

Once you have made sure your device's bootloader is unlocked and that you have a custom recovery installed, you can proceed with the following steps:

- Download the latest available UN1CA zip package for your device
- Reboot your device into recovery mode, there are multiple ways to achieve so:
  - **Key combo**: power off your device, connect it to your PC via an USB cable and press the recovery mode key combo for your device.
  - **ADB**: connect your device to your PC via an USB cable and run the following command:
    ```bash
    adb reboot recovery
    ```
  - **Magisk/KernelSU Manager**: open the Magisk/KernelSU Manager app and select "Reboot to recovery" option in the Toolbar menu.
- Open the Install menu, select the UN1CA package you previously downloaded and flash it. UI might vary depending which recovery you have installed.
- Your specific device installer might have a "Post-install" feature enabled which will automatically reboot your device a few times. Don't worry about it.
- Once the installation has finished, open the Wipe → Format Data menu, type "yes" and confirm. **This step is only required the very first time you install the ROM.**

If you followed every step correctly, the ROM has been installed succesfully and you can now exit recovery by selecting Reboot → System.

If you encounter any error/issue, please refer to the [Troubleshooting]({% link faq/index.md %}) section.

## Updating the ROM
{: .pb-2 }
To update the ROM, you can simply follow the same exact steps you've followed for the first time install, expection made for the data wipe which is not necessary anymore.
