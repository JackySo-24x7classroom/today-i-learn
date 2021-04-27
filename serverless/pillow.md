# Build pillow archive for Lambda use

> The AWS Lambda function uses the Pillow library for the generation of thumbnail images. This library needs to be added into our project so that we can allow the CDK to package it and create an AWS Lambda Layer

**Scope-of-work**
- [x] Launch Amazon EC2 Instance using Amazone Linux 2 AMI
  - [x] SSH or SSM session into running EC2 instance
- [x] Build pillow archive in EC2 instance
  - [x] Install python packages
    - [x] python3-pip
    - [x] python3
    - [x] python3-setuptools
  - [x] Build pillow in python virtual environment
    - [x] Activiate virtual environment
    - [x] Install pillow through pip manager
    - [x] Make zip archive of pillow and python
- [x] Download pillow archive from EC2 instance to your workstation
    - [x] Validate zip archive

<details><summary><i>Click HERE to view work and command output</i></summary><br>

```bash
[root@ip-172-24-121-11 bin]# uname -a
Linux ip-172-24-121-11 4.14.177-139.254.amzn2.x86_64 #1 SMP Thu May 7 18:48:23 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
[root@ip-172-24-121-11 bin]# su - ec2-user
[ec2-user@ip-172-24-121-11 ~]$ pwd
/home/ec2-user
[ec2-user@ip-172-24-121-11 ~]$ ls

[ec2-user@ip-172-24-121-11 ~]$ sudo yum install -y python3-pip python3 python3-setuptools
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
amzn2-core                                                                                                                                     | 3.7 kB  00:00:00
amzn2extra-ansible2                                                                                                                            | 3.0 kB  00:00:00
amzn2extra-docker                                                                                                                              | 3.0 kB  00:00:00
amzn2extra-epel                                                                                                                                | 3.0 kB  00:00:00
epel/x86_64/metalink                                                                                                                           |  36 kB  00:00:00
235 packages excluded due to repository priority protections
Package python3-pip-9.0.3-1.amzn2.0.2.noarch already installed and latest version
Package python3-setuptools-38.4.0-3.amzn2.0.6.noarch already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package python3.x86_64 0:3.7.6-1.amzn2.0.1 will be updated
--> Processing Dependency: python3(x86-64) = 3.7.6-1.amzn2.0.1 for package: python3-libs-3.7.6-1.amzn2.0.1.x86_64
---> Package python3.x86_64 0:3.7.9-1.amzn2.0.2 will be an update
--> Running transaction check
---> Package python3-libs.x86_64 0:3.7.6-1.amzn2.0.1 will be updated
---> Package python3-libs.x86_64 0:3.7.9-1.amzn2.0.2 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

======================================================================================================================================================================
 Package                                 Arch                              Version                                        Repository                             Size
======================================================================================================================================================================
Updating:
 python3                                 x86_64                            3.7.9-1.amzn2.0.2                              amzn2-core                             72 k
Updating for dependencies:
 python3-libs                            x86_64                            3.7.9-1.amzn2.0.2                              amzn2-core                            9.2 M

Transaction Summary
======================================================================================================================================================================
Upgrade  1 Package (+1 Dependent package)

Total download size: 9.2 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/2): python3-3.7.9-1.amzn2.0.2.x86_64.rpm                                                                                                    |  72 kB  00:00:00
(2/2): python3-libs-3.7.9-1.amzn2.0.2.x86_64.rpm                                                                                               | 9.2 MB  00:00:00
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                  45 MB/s | 9.2 MB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
  Updating   : python3-3.7.9-1.amzn2.0.2.x86_64                                                                                                                   1/4
  Updating   : python3-libs-3.7.9-1.amzn2.0.2.x86_64                                                                                                              2/4
  Cleanup    : python3-3.7.6-1.amzn2.0.1.x86_64                                                                                                                   3/4
  Cleanup    : python3-libs-3.7.6-1.amzn2.0.1.x86_64                                                                                                              4/4
  Verifying  : python3-libs-3.7.9-1.amzn2.0.2.x86_64                                                                                                              1/4
  Verifying  : python3-3.7.9-1.amzn2.0.2.x86_64                                                                                                                   2/4
  Verifying  : python3-libs-3.7.6-1.amzn2.0.1.x86_64                                                                                                              3/4
  Verifying  : python3-3.7.6-1.amzn2.0.1.x86_64                                                                                                                   4/4

Updated:
  python3.x86_64 0:3.7.9-1.amzn2.0.2

Dependency Updated:
  python3-libs.x86_64 0:3.7.9-1.amzn2.0.2

Complete!

[ec2-user@ip-172-24-121-11 ~]$ id
uid=1000(ec2-user) gid=1000(ec2-user) groups=1000(ec2-user),4(adm),10(wheel),190(systemd-journal)
[ec2-user@ip-172-24-121-11 ~]$ pwd
/home/ec2-user
[ec2-user@ip-172-24-121-11 ~]$ python3 -m venv my_app/env
[ec2-user@ip-172-24-121-11 ~]$ source ~/my_app/env/bin/activate
(env) [ec2-user@ip-172-24-121-11 ~]$ ls -al
total 16
drwx------ 6 ec2-user ec2-user 139 Apr 27 00:43 .
drwxr-xr-x 5 root     root      50 Jun  4  2020 ..
drwx------ 4 ec2-user ec2-user  50 Jun  3  2020 .ansible
-rw------- 1 ec2-user ec2-user  15 Jan 27 01:01 .bash_history
-rw-r--r-- 1 ec2-user ec2-user  18 Jan 16  2020 .bash_logout
-rw-r--r-- 1 ec2-user ec2-user 193 Jan 16  2020 .bash_profile
-rw-r--r-- 1 ec2-user ec2-user 231 Jan 16  2020 .bashrc
drwx------ 3 ec2-user root      25 Jun  3  2020 .cache
drwxrwxr-x 3 ec2-user ec2-user  17 Apr 27 00:43 my_app
drwx------ 2 ec2-user ec2-user  29 Jun  3  2020 .ssh

(env) [ec2-user@ip-172-24-121-11 ~]$ cd my_app/env

(env) [ec2-user@ip-172-24-121-11 env]$ pip3 install pillow
Collecting pillow
  Downloading Pillow-8.2.0-cp37-cp37m-manylinux1_x86_64.whl (3.0 MB)
     |████████████████████████████████| 3.0 MB 16.9 MB/s
Installing collected packages: pillow
Successfully installed pillow-8.2.0
(env) [ec2-user@ip-172-24-121-11 env]$ cd /home/ec2-user/my_app/env/lib/python3.7/site-packages

(env) [ec2-user@ip-172-24-121-11 site-packages]$ mkdir python && cp -R ./PIL ./python && cp -R ./Pillow-8.2.0.dist-info ./python && cp -R ./Pillow.libs ./python && zip -r pillow.zip ./python
  adding: python/ (stored 0%)
  adding: python/PIL/ (stored 0%)
  adding: python/PIL/_binary.py (deflated 71%)
  adding: python/PIL/ImageGrab.py (deflated 64%)
  adding: python/PIL/BmpImagePlugin.py (deflated 72%)
  adding: python/PIL/ImageFile.py (deflated 71%)
  adding: python/PIL/_imaging.cpython-37m-x86_64-linux-gnu.so (deflated 62%)
  adding: python/PIL/XVThumbImagePlugin.py (deflated 53%)
  adding: python/PIL/PdfImagePlugin.py (deflated 70%)
  adding: python/PIL/_imagingmorph.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/PIL/PpmImagePlugin.py (deflated 67%)
  adding: python/PIL/ImagePath.py (deflated 29%)
  adding: python/PIL/Jpeg2KImagePlugin.py (deflated 71%)
  adding: python/PIL/PalmImagePlugin.py (deflated 74%)
  adding: python/PIL/GribStubImagePlugin.py (deflated 58%)
  adding: python/PIL/Image.py (deflated 74%)
  adding: python/PIL/TarIO.py (deflated 52%)
  adding: python/PIL/PcfFontFile.py (deflated 69%)
  adding: python/PIL/ImageTk.py (deflated 69%)
  adding: python/PIL/FpxImagePlugin.py (deflated 66%)
  adding: python/PIL/WalImageFile.py (deflated 64%)
  adding: python/PIL/WmfImagePlugin.py (deflated 65%)
  adding: python/PIL/ImageFont.py (deflated 76%)
  adding: python/PIL/ImageStat.py (deflated 69%)
  adding: python/PIL/ImImagePlugin.py (deflated 68%)
  adding: python/PIL/MpoImagePlugin.py (deflated 60%)
  adding: python/PIL/DcxImagePlugin.py (deflated 55%)
  adding: python/PIL/ImageCms.py (deflated 78%)
  adding: python/PIL/__init__.py (deflated 71%)
  adding: python/PIL/PyAccess.py (deflated 76%)
  adding: python/PIL/_webp.cpython-37m-x86_64-linux-gnu.so (deflated 79%)
  adding: python/PIL/ImageOps.py (deflated 72%)
  adding: python/PIL/PdfParser.py (deflated 77%)
  adding: python/PIL/GbrImagePlugin.py (deflated 61%)
  adding: python/PIL/ImageWin.py (deflated 68%)
  adding: python/PIL/FitsStubImagePlugin.py (deflated 57%)
  adding: python/PIL/PngImagePlugin.py (deflated 75%)
  adding: python/PIL/JpegPresets.py (deflated 84%)
  adding: python/PIL/ImageFilter.py (deflated 73%)
  adding: python/PIL/JpegImagePlugin.py (deflated 69%)
  adding: python/PIL/_version.py (deflated 6%)
  adding: python/PIL/GimpPaletteFile.py (deflated 52%)
  adding: python/PIL/PSDraw.py (deflated 64%)
  adding: python/PIL/TiffImagePlugin.py (deflated 73%)
  adding: python/PIL/EpsImagePlugin.py (deflated 66%)
  adding: python/PIL/BlpImagePlugin.py (deflated 78%)
  adding: python/PIL/ImageColor.py (deflated 68%)
  adding: python/PIL/IcoImagePlugin.py (deflated 66%)
  adding: python/PIL/MpegImagePlugin.py (deflated 62%)
  adding: python/PIL/_imagingtk.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/PIL/BdfFontFile.py (deflated 57%)
  adding: python/PIL/PcxImagePlugin.py (deflated 63%)
  adding: python/PIL/SunImagePlugin.py (deflated 64%)
  adding: python/PIL/MspImagePlugin.py (deflated 61%)
  adding: python/PIL/PaletteFile.py (deflated 51%)
  adding: python/PIL/ContainerIO.py (deflated 66%)
  adding: python/PIL/ImageQt.py (deflated 63%)
  adding: python/PIL/FliImagePlugin.py (deflated 64%)
  adding: python/PIL/GimpGradientFile.py (deflated 63%)
  adding: python/PIL/ImageMode.py (deflated 66%)
  adding: python/PIL/ImageTransform.py (deflated 60%)
  adding: python/PIL/GdImageFile.py (deflated 54%)
  adding: python/PIL/XbmImagePlugin.py (deflated 57%)
  adding: python/PIL/ImageDraw.py (deflated 78%)
  adding: python/PIL/ImagePalette.py (deflated 68%)
  adding: python/PIL/TgaImagePlugin.py (deflated 70%)
  adding: python/PIL/FtexImagePlugin.py (deflated 60%)
  adding: python/PIL/MicImagePlugin.py (deflated 61%)
  adding: python/PIL/IcnsImagePlugin.py (deflated 68%)
  adding: python/PIL/ExifTags.py (deflated 67%)
  adding: python/PIL/__main__.py (deflated 10%)
  adding: python/PIL/FontFile.py (deflated 62%)
  adding: python/PIL/TiffTags.py (deflated 63%)
  adding: python/PIL/ImageSequence.py (deflated 57%)
  adding: python/PIL/BufrStubImagePlugin.py (deflated 58%)
  adding: python/PIL/_imagingft.cpython-37m-x86_64-linux-gnu.so (deflated 65%)
  adding: python/PIL/ImageEnhance.py (deflated 67%)
  adding: python/PIL/_imagingmath.cpython-37m-x86_64-linux-gnu.so (deflated 69%)
  adding: python/PIL/PixarImagePlugin.py (deflated 51%)
  adding: python/PIL/ImageShow.py (deflated 69%)
  adding: python/PIL/SgiImagePlugin.py (deflated 64%)
  adding: python/PIL/PcdImagePlugin.py (deflated 53%)
  adding: python/PIL/_imagingcms.cpython-37m-x86_64-linux-gnu.so (deflated 69%)
  adding: python/PIL/IptcImagePlugin.py (deflated 63%)
  adding: python/PIL/DdsImagePlugin.py (deflated 68%)
  adding: python/PIL/CurImagePlugin.py (deflated 58%)
  adding: python/PIL/_tkinter_finder.py (deflated 41%)
  adding: python/PIL/ImageChops.py (deflated 78%)
  adding: python/PIL/GifImagePlugin.py (deflated 73%)
  adding: python/PIL/ImageDraw2.py (deflated 73%)
  adding: python/PIL/ImageMorph.py (deflated 68%)
  adding: python/PIL/features.py (deflated 75%)
  adding: python/PIL/_util.py (deflated 42%)
  adding: python/PIL/Hdf5StubImagePlugin.py (deflated 58%)
  adding: python/PIL/McIdasImagePlugin.py (deflated 56%)
  adding: python/PIL/PsdImagePlugin.py (deflated 69%)
  adding: python/PIL/ImageMath.py (deflated 74%)
  adding: python/PIL/XpmImagePlugin.py (deflated 62%)
  adding: python/PIL/SpiderImagePlugin.py (deflated 66%)
  adding: python/PIL/ImtImagePlugin.py (deflated 58%)
  adding: python/PIL/WebPImagePlugin.py (deflated 71%)
  adding: python/PIL/__pycache__/ (stored 0%)
  adding: python/PIL/__pycache__/MpoImagePlugin.cpython-37.pyc (deflated 46%)
  adding: python/PIL/__pycache__/BdfFontFile.cpython-37.pyc (deflated 36%)
  adding: python/PIL/__pycache__/ImageMath.cpython-37.pyc (deflated 65%)
  adding: python/PIL/__pycache__/BlpImagePlugin.cpython-37.pyc (deflated 52%)
  adding: python/PIL/__pycache__/ImageGrab.cpython-37.pyc (deflated 35%)
  adding: python/PIL/__pycache__/BmpImagePlugin.cpython-37.pyc (deflated 45%)
  adding: python/PIL/__pycache__/ImageMode.cpython-37.pyc (deflated 47%)
  adding: python/PIL/__pycache__/BufrStubImagePlugin.cpython-37.pyc (deflated 43%)
  adding: python/PIL/__pycache__/MspImagePlugin.cpython-37.pyc (deflated 40%)
  adding: python/PIL/__pycache__/ContainerIO.cpython-37.pyc (deflated 52%)
  adding: python/PIL/__pycache__/ImageMorph.cpython-37.pyc (deflated 52%)
  adding: python/PIL/__pycache__/CurImagePlugin.cpython-37.pyc (deflated 35%)
  adding: python/PIL/__pycache__/ImageOps.cpython-37.pyc (deflated 57%)
  adding: python/PIL/__pycache__/DcxImagePlugin.cpython-37.pyc (deflated 41%)
  adding: python/PIL/__pycache__/ImageSequence.cpython-37.pyc (deflated 46%)
  adding: python/PIL/__pycache__/DdsImagePlugin.cpython-37.pyc (deflated 44%)
  adding: python/PIL/__pycache__/ImageShow.cpython-37.pyc (deflated 56%)
  adding: python/PIL/__pycache__/EpsImagePlugin.cpython-37.pyc (deflated 42%)
  adding: python/PIL/__pycache__/PcdImagePlugin.cpython-37.pyc (deflated 36%)
  adding: python/PIL/__pycache__/ExifTags.cpython-37.pyc (deflated 52%)
  adding: python/PIL/__pycache__/ImageStat.cpython-37.pyc (deflated 53%)
  adding: python/PIL/__pycache__/FitsStubImagePlugin.cpython-37.pyc (deflated 42%)
  adding: python/PIL/__pycache__/ImageTk.cpython-37.pyc (deflated 55%)
  adding: python/PIL/__pycache__/FliImagePlugin.cpython-37.pyc (deflated 43%)
  adding: python/PIL/__pycache__/PaletteFile.cpython-37.pyc (deflated 38%)
  adding: python/PIL/__pycache__/FontFile.cpython-37.pyc (deflated 38%)
  adding: python/PIL/__pycache__/ImageTransform.cpython-37.pyc (deflated 57%)
  adding: python/PIL/__pycache__/FpxImagePlugin.cpython-37.pyc (deflated 40%)
  adding: python/PIL/__pycache__/ImageWin.cpython-37.pyc (deflated 59%)
  adding: python/PIL/__pycache__/FtexImagePlugin.cpython-37.pyc (deflated 48%)
  adding: python/PIL/__pycache__/ImtImagePlugin.cpython-37.pyc (deflated 32%)
  adding: python/PIL/__pycache__/GbrImagePlugin.cpython-37.pyc (deflated 41%)
  adding: python/PIL/__pycache__/PalmImagePlugin.cpython-37.pyc (deflated 68%)
  adding: python/PIL/__pycache__/GdImageFile.cpython-37.pyc (deflated 41%)
  adding: python/PIL/__pycache__/IptcImagePlugin.cpython-37.pyc (deflated 41%)
  adding: python/PIL/__pycache__/GifImagePlugin.cpython-37.pyc (deflated 48%)
  adding: python/PIL/__pycache__/Jpeg2KImagePlugin.cpython-37.pyc (deflated 44%)
  adding: python/PIL/__pycache__/GimpGradientFile.cpython-37.pyc (deflated 44%)
  adding: python/PIL/__pycache__/JpegImagePlugin.cpython-37.pyc (deflated 48%)
  adding: python/PIL/__pycache__/GimpPaletteFile.cpython-37.pyc (deflated 38%)
  adding: python/PIL/__pycache__/JpegPresets.cpython-37.pyc (deflated 64%)
  adding: python/PIL/__pycache__/GribStubImagePlugin.cpython-37.pyc (deflated 43%)
  adding: python/PIL/__pycache__/McIdasImagePlugin.cpython-37.pyc (deflated 37%)
  adding: python/PIL/__pycache__/Hdf5StubImagePlugin.cpython-37.pyc (deflated 42%)
  adding: python/PIL/__pycache__/MicImagePlugin.cpython-37.pyc (deflated 40%)
  adding: python/PIL/__pycache__/IcnsImagePlugin.cpython-37.pyc (deflated 46%)
  adding: python/PIL/__pycache__/MpegImagePlugin.cpython-37.pyc (deflated 47%)
  adding: python/PIL/__pycache__/IcoImagePlugin.cpython-37.pyc (deflated 47%)
  adding: python/PIL/__pycache__/PdfImagePlugin.cpython-37.pyc (deflated 37%)
  adding: python/PIL/__pycache__/ImImagePlugin.cpython-37.pyc (deflated 44%)
  adding: python/PIL/__pycache__/TarIO.cpython-37.pyc (deflated 40%)
  adding: python/PIL/__pycache__/Image.cpython-37.pyc (deflated 61%)
  adding: python/PIL/__pycache__/PcfFontFile.cpython-37.pyc (deflated 47%)
  adding: python/PIL/__pycache__/ImageChops.cpython-37.pyc (deflated 73%)
  adding: python/PIL/__pycache__/PcxImagePlugin.cpython-37.pyc (deflated 43%)
  adding: python/PIL/__pycache__/ImageCms.cpython-37.pyc (deflated 70%)
  adding: python/PIL/__pycache__/PngImagePlugin.cpython-37.pyc (deflated 54%)
  adding: python/PIL/__pycache__/ImageColor.cpython-37.pyc (deflated 53%)
  adding: python/PIL/__pycache__/PdfParser.cpython-37.pyc (deflated 55%)
  adding: python/PIL/__pycache__/ImageDraw.cpython-37.pyc (deflated 56%)
  adding: python/PIL/__pycache__/PixarImagePlugin.cpython-37.pyc (deflated 36%)
  adding: python/PIL/__pycache__/ImageDraw2.cpython-37.pyc (deflated 62%)
  adding: python/PIL/__pycache__/PpmImagePlugin.cpython-37.pyc (deflated 40%)
  adding: python/PIL/__pycache__/ImageEnhance.cpython-37.pyc (deflated 59%)
  adding: python/PIL/__pycache__/PsdImagePlugin.cpython-37.pyc (deflated 43%)
  adding: python/PIL/__pycache__/ImageFile.cpython-37.pyc (deflated 51%)
  adding: python/PIL/__pycache__/SpiderImagePlugin.cpython-37.pyc (deflated 46%)
  adding: python/PIL/__pycache__/ImageFilter.cpython-37.pyc (deflated 63%)
  adding: python/PIL/__pycache__/PyAccess.cpython-37.pyc (deflated 68%)
  adding: python/PIL/__pycache__/ImageFont.cpython-37.pyc (deflated 70%)
  adding: python/PIL/__pycache__/ImagePalette.cpython-37.pyc (deflated 50%)
  adding: python/PIL/__pycache__/SgiImagePlugin.cpython-37.pyc (deflated 43%)
  adding: python/PIL/__pycache__/ImagePath.cpython-37.pyc (deflated 15%)
  adding: python/PIL/__pycache__/SunImagePlugin.cpython-37.pyc (deflated 39%)
  adding: python/PIL/__pycache__/ImageQt.cpython-37.pyc (deflated 41%)
  adding: python/PIL/__pycache__/TgaImagePlugin.cpython-37.pyc (deflated 43%)
  adding: python/PIL/__pycache__/PSDraw.cpython-37.pyc (deflated 54%)
  adding: python/PIL/__pycache__/TiffImagePlugin.cpython-37.pyc (deflated 57%)
  adding: python/PIL/__pycache__/TiffTags.cpython-37.pyc (deflated 49%)
  adding: python/PIL/__pycache__/WalImageFile.cpython-37.pyc (deflated 29%)
  adding: python/PIL/__pycache__/WebPImagePlugin.cpython-37.pyc (deflated 44%)
  adding: python/PIL/__pycache__/WmfImagePlugin.cpython-37.pyc (deflated 44%)
  adding: python/PIL/__pycache__/XVThumbImagePlugin.cpython-37.pyc (deflated 35%)
  adding: python/PIL/__pycache__/XbmImagePlugin.cpython-37.pyc (deflated 42%)
  adding: python/PIL/__pycache__/XpmImagePlugin.cpython-37.pyc (deflated 37%)
  adding: python/PIL/__pycache__/__init__.cpython-37.pyc (deflated 58%)
  adding: python/PIL/__pycache__/__main__.cpython-37.pyc (deflated 14%)
  adding: python/PIL/__pycache__/_binary.cpython-37.pyc (deflated 68%)
  adding: python/PIL/__pycache__/_tkinter_finder.cpython-37.pyc (deflated 24%)
  adding: python/PIL/__pycache__/_util.cpython-37.pyc (deflated 44%)
  adding: python/PIL/__pycache__/_version.cpython-37.pyc (deflated 18%)
  adding: python/PIL/__pycache__/features.cpython-37.pyc (deflated 58%)
  adding: python/Pillow-8.2.0.dist-info/ (stored 0%)
  adding: python/Pillow-8.2.0.dist-info/zip-safe (stored 0%)
  adding: python/Pillow-8.2.0.dist-info/RECORD (deflated 57%)
  adding: python/Pillow-8.2.0.dist-info/top_level.txt (stored 0%)
  adding: python/Pillow-8.2.0.dist-info/METADATA (deflated 73%)
  adding: python/Pillow-8.2.0.dist-info/LICENSE (deflated 70%)
  adding: python/Pillow-8.2.0.dist-info/WHEEL (deflated 3%)
  adding: python/Pillow-8.2.0.dist-info/INSTALLER (stored 0%)
  adding: python/Pillow.libs/ (stored 0%)
  adding: python/Pillow.libs/libXdmcp-e15573e7.so.6.0.0 (deflated 62%)
  adding: python/Pillow.libs/libopenjp2-f0612b30.so.2.4.0 (deflated 72%)
  adding: python/Pillow.libs/libpng16-bedcb7ea.so.16.37.0 (deflated 66%)
  adding: python/Pillow.libs/libwebpmux-1d369df0.so.3.0.6 (deflated 61%)
  adding: python/Pillow.libs/libwebpdemux-2a7a19d5.so.2.0.7 (deflated 69%)
  adding: python/Pillow.libs/libxcb-2dfad6c3.so.1.1.0 (deflated 82%)
  adding: python/Pillow.libs/liblcms2-a76503ec.so.2.0.12 (deflated 67%)
  adding: python/Pillow.libs/libtiff-d147fec3.so.5.6.0 (deflated 75%)
  adding: python/Pillow.libs/libwebp-305e7d94.so.7.1.1 (deflated 53%)
  adding: python/Pillow.libs/libz-a147dcb0.so.1.2.3 (deflated 51%)
  adding: python/Pillow.libs/libXau-312dbc56.so.6.0.0 (deflated 65%)
  adding: python/Pillow.libs/libjpeg-ba7bf5af.so.9.4.0 (deflated 53%)
  adding: python/Pillow.libs/libharfbuzz-ba5e3cba.so.0.20800.0 (deflated 75%)
  adding: python/Pillow.libs/libfreetype-6ad068c6.so.6.17.4 (deflated 65%)
  adding: python/Pillow.libs/liblzma-99449165.so.5.2.5 (deflated 65%)

(env) [ec2-user@ip-172-24-121-11 site-packages]$ du -sh pillow.zip
3.2M	pillow.zip
```

</details><br>

<details><summary><i>Click HERE to view content of pillow.zip</i></summary><br>

```bash
$  ssm --list
i-0546db675efacbc30    ip-172-24-121-11                                dev-jscape-poc   172.24.121.11
i-0d8105e90abc17605    ip-10-92-1-48.ap-southeast-2.compute.internal   live-box         10.92.1.48 52.65.116.86

$  scp ec2-user@i-0546db675efacbc30:my_app/env/lib/python3.7/site-packages/pillow.zip .
pillow.zip                                                                                                                          100% 3222KB 846.4KB/s   00:03

$  zip -sf pillow.zip
Archive contains:
  python/
  python/PIL/
  python/PIL/_binary.py
  python/PIL/ImageGrab.py
  python/PIL/BmpImagePlugin.py
  python/PIL/ImageFile.py
  python/PIL/_imaging.cpython-37m-x86_64-linux-gnu.so
  python/PIL/XVThumbImagePlugin.py
  python/PIL/PdfImagePlugin.py
  python/PIL/_imagingmorph.cpython-37m-x86_64-linux-gnu.so
  python/PIL/PpmImagePlugin.py
  python/PIL/ImagePath.py
  python/PIL/Jpeg2KImagePlugin.py
  python/PIL/PalmImagePlugin.py
  python/PIL/GribStubImagePlugin.py
  python/PIL/Image.py
  python/PIL/TarIO.py
  python/PIL/PcfFontFile.py
  python/PIL/ImageTk.py
  python/PIL/FpxImagePlugin.py
  python/PIL/WalImageFile.py
  python/PIL/WmfImagePlugin.py
  python/PIL/ImageFont.py
  python/PIL/ImageStat.py
  python/PIL/ImImagePlugin.py
  python/PIL/MpoImagePlugin.py
  python/PIL/DcxImagePlugin.py
  python/PIL/ImageCms.py
  python/PIL/__init__.py
  python/PIL/PyAccess.py
  python/PIL/_webp.cpython-37m-x86_64-linux-gnu.so
  python/PIL/ImageOps.py
  python/PIL/PdfParser.py
  python/PIL/GbrImagePlugin.py
  python/PIL/ImageWin.py
  python/PIL/FitsStubImagePlugin.py
  python/PIL/PngImagePlugin.py
  python/PIL/JpegPresets.py
  python/PIL/ImageFilter.py
  python/PIL/JpegImagePlugin.py
  python/PIL/_version.py
  python/PIL/GimpPaletteFile.py
  python/PIL/PSDraw.py
  python/PIL/TiffImagePlugin.py
  python/PIL/EpsImagePlugin.py
  python/PIL/BlpImagePlugin.py
  python/PIL/ImageColor.py
  python/PIL/IcoImagePlugin.py
  python/PIL/MpegImagePlugin.py
  python/PIL/_imagingtk.cpython-37m-x86_64-linux-gnu.so
  python/PIL/BdfFontFile.py
  python/PIL/PcxImagePlugin.py
  python/PIL/SunImagePlugin.py
  python/PIL/MspImagePlugin.py
  python/PIL/PaletteFile.py
  python/PIL/ContainerIO.py
  python/PIL/ImageQt.py
  python/PIL/FliImagePlugin.py
  python/PIL/GimpGradientFile.py
  python/PIL/ImageMode.py
  python/PIL/ImageTransform.py
  python/PIL/GdImageFile.py
  python/PIL/XbmImagePlugin.py
  python/PIL/ImageDraw.py
  python/PIL/ImagePalette.py
  python/PIL/TgaImagePlugin.py
  python/PIL/FtexImagePlugin.py
  python/PIL/MicImagePlugin.py
  python/PIL/IcnsImagePlugin.py
  python/PIL/ExifTags.py
  python/PIL/__main__.py
  python/PIL/FontFile.py
  python/PIL/TiffTags.py
  python/PIL/ImageSequence.py
  python/PIL/BufrStubImagePlugin.py
  python/PIL/_imagingft.cpython-37m-x86_64-linux-gnu.so
  python/PIL/ImageEnhance.py
  python/PIL/_imagingmath.cpython-37m-x86_64-linux-gnu.so
  python/PIL/PixarImagePlugin.py
  python/PIL/ImageShow.py
  python/PIL/SgiImagePlugin.py
  python/PIL/PcdImagePlugin.py
  python/PIL/_imagingcms.cpython-37m-x86_64-linux-gnu.so
  python/PIL/IptcImagePlugin.py
  python/PIL/DdsImagePlugin.py
  python/PIL/CurImagePlugin.py
  python/PIL/_tkinter_finder.py
  python/PIL/ImageChops.py
  python/PIL/GifImagePlugin.py
  python/PIL/ImageDraw2.py
  python/PIL/ImageMorph.py
  python/PIL/features.py
  python/PIL/_util.py
  python/PIL/Hdf5StubImagePlugin.py
  python/PIL/McIdasImagePlugin.py
  python/PIL/PsdImagePlugin.py
  python/PIL/ImageMath.py
  python/PIL/XpmImagePlugin.py
  python/PIL/SpiderImagePlugin.py
  python/PIL/ImtImagePlugin.py
  python/PIL/WebPImagePlugin.py
  python/PIL/__pycache__/
  python/PIL/__pycache__/MpoImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/BdfFontFile.cpython-37.pyc
  python/PIL/__pycache__/ImageMath.cpython-37.pyc
  python/PIL/__pycache__/BlpImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageGrab.cpython-37.pyc
  python/PIL/__pycache__/BmpImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageMode.cpython-37.pyc
  python/PIL/__pycache__/BufrStubImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/MspImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ContainerIO.cpython-37.pyc
  python/PIL/__pycache__/ImageMorph.cpython-37.pyc
  python/PIL/__pycache__/CurImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageOps.cpython-37.pyc
  python/PIL/__pycache__/DcxImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageSequence.cpython-37.pyc
  python/PIL/__pycache__/DdsImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageShow.cpython-37.pyc
  python/PIL/__pycache__/EpsImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/PcdImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ExifTags.cpython-37.pyc
  python/PIL/__pycache__/ImageStat.cpython-37.pyc
  python/PIL/__pycache__/FitsStubImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageTk.cpython-37.pyc
  python/PIL/__pycache__/FliImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/PaletteFile.cpython-37.pyc
  python/PIL/__pycache__/FontFile.cpython-37.pyc
  python/PIL/__pycache__/ImageTransform.cpython-37.pyc
  python/PIL/__pycache__/FpxImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageWin.cpython-37.pyc
  python/PIL/__pycache__/FtexImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImtImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/GbrImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/PalmImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/GdImageFile.cpython-37.pyc
  python/PIL/__pycache__/IptcImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/GifImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/Jpeg2KImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/GimpGradientFile.cpython-37.pyc
  python/PIL/__pycache__/JpegImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/GimpPaletteFile.cpython-37.pyc
  python/PIL/__pycache__/JpegPresets.cpython-37.pyc
  python/PIL/__pycache__/GribStubImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/McIdasImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/Hdf5StubImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/MicImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/IcnsImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/MpegImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/IcoImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/PdfImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/TarIO.cpython-37.pyc
  python/PIL/__pycache__/Image.cpython-37.pyc
  python/PIL/__pycache__/PcfFontFile.cpython-37.pyc
  python/PIL/__pycache__/ImageChops.cpython-37.pyc
  python/PIL/__pycache__/PcxImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageCms.cpython-37.pyc
  python/PIL/__pycache__/PngImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageColor.cpython-37.pyc
  python/PIL/__pycache__/PdfParser.cpython-37.pyc
  python/PIL/__pycache__/ImageDraw.cpython-37.pyc
  python/PIL/__pycache__/PixarImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageDraw2.cpython-37.pyc
  python/PIL/__pycache__/PpmImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageEnhance.cpython-37.pyc
  python/PIL/__pycache__/PsdImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageFile.cpython-37.pyc
  python/PIL/__pycache__/SpiderImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageFilter.cpython-37.pyc
  python/PIL/__pycache__/PyAccess.cpython-37.pyc
  python/PIL/__pycache__/ImageFont.cpython-37.pyc
  python/PIL/__pycache__/ImagePalette.cpython-37.pyc
  python/PIL/__pycache__/SgiImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImagePath.cpython-37.pyc
  python/PIL/__pycache__/SunImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/ImageQt.cpython-37.pyc
  python/PIL/__pycache__/TgaImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/PSDraw.cpython-37.pyc
  python/PIL/__pycache__/TiffImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/TiffTags.cpython-37.pyc
  python/PIL/__pycache__/WalImageFile.cpython-37.pyc
  python/PIL/__pycache__/WebPImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/WmfImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/XVThumbImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/XbmImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/XpmImagePlugin.cpython-37.pyc
  python/PIL/__pycache__/__init__.cpython-37.pyc
  python/PIL/__pycache__/__main__.cpython-37.pyc
  python/PIL/__pycache__/_binary.cpython-37.pyc
  python/PIL/__pycache__/_tkinter_finder.cpython-37.pyc
  python/PIL/__pycache__/_util.cpython-37.pyc
  python/PIL/__pycache__/_version.cpython-37.pyc
  python/PIL/__pycache__/features.cpython-37.pyc
  python/Pillow-8.2.0.dist-info/
  python/Pillow-8.2.0.dist-info/zip-safe
  python/Pillow-8.2.0.dist-info/RECORD
  python/Pillow-8.2.0.dist-info/top_level.txt
  python/Pillow-8.2.0.dist-info/METADATA
  python/Pillow-8.2.0.dist-info/LICENSE
  python/Pillow-8.2.0.dist-info/WHEEL
  python/Pillow-8.2.0.dist-info/INSTALLER
  python/Pillow.libs/
  python/Pillow.libs/libXdmcp-e15573e7.so.6.0.0
  python/Pillow.libs/libopenjp2-f0612b30.so.2.4.0
  python/Pillow.libs/libpng16-bedcb7ea.so.16.37.0
  python/Pillow.libs/libwebpmux-1d369df0.so.3.0.6
  python/Pillow.libs/libwebpdemux-2a7a19d5.so.2.0.7
  python/Pillow.libs/libxcb-2dfad6c3.so.1.1.0
  python/Pillow.libs/liblcms2-a76503ec.so.2.0.12
  python/Pillow.libs/libtiff-d147fec3.so.5.6.0
  python/Pillow.libs/libwebp-305e7d94.so.7.1.1
  python/Pillow.libs/libz-a147dcb0.so.1.2.3
  python/Pillow.libs/libXau-312dbc56.so.6.0.0
  python/Pillow.libs/libjpeg-ba7bf5af.so.9.4.0
  python/Pillow.libs/libharfbuzz-ba5e3cba.so.0.20800.0
  python/Pillow.libs/libfreetype-6ad068c6.so.6.17.4
  python/Pillow.libs/liblzma-99449165.so.5.2.5
Total 218 entries (10214681 bytes)

```

</details><br>
