#!/bin/bash
needed_packages=boost
pacman -Q $needed_packages || sudo pacman -S --needed $needed_packages
