# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 systemd
EGIT_REPO_URI="https://github.com/Petingoso/legion-fan-utils-linux.git"

DESCRIPTION="Small Scripts for Lenovo Legion Laptops"
HOMEPAGE="https://github.com/Petingoso/legion-fan-utils-linux"

DEPEND="sys-firmware/lenovolegionlinux
        dev-python/psutil
        radeon_dgpu? ( dev-util/rocm-smi )
        downgrade-nvidia? ( <=x11-drivers/nvidia-drivers-525 )
        acpi? ( sys-power/acpid )
        app-portage/smart-live-rebuild
        ryzenadj? ( sys-power/RyzenAdj )"
LICENSE="GPL-3"
SLOT="0"
IUSE="systemd acpi radeon_dgpu downgrade-nvidia ryzenadj"
REQUIRED_USE="|| ( systemd acpi radeon_dgpu downgrade-nvidia ryzenadj ) radeon_dgpu? ( !downgrade-nvidia ) downgrade-nvidia? ( !radeon_dgpu )"

src_install() {
    insinto /etc/lenovo-fan-control/ && doins service/fancurve-set.sh
    insinto /etc/lenovo-fan-control/profiles/ && doins service/profiles/*
    insinto /etc/lenovo-fan-control/ && doins service/lenovo-legion-fan-service.py && doins profile_man.py
    fperms +x /etc/lenovo-fan-control/fancurve-set.sh
    fperms +x /etc/lenovo-fan-control/lenovo-legion-fan-service.py
    fperms +x /etc/lenovo-fan-control/profile_man.py

    #AMD
    if use radeon_dgpu; then
        cp .env-files/radeon .env
        insinto /etc/lenovo-fan-control/ && doins .env
    fi

    #NVIDIA (need dowgrade because nvidia-smi -pl was removed)
    if use downgrade-nvidia; then 
        cp .env-files/nvidia .env
        insinto /etc/lenovo-fan-control/ && doins .env
    fi

	if use systemd; then
        systemd_dounit service/lenovo-fancurve.service service/lenovo-fancurve-restart.service service/lenovo-fancurve-restart.path

        if use acpi; then
        insinto /etc/acpi/events/ && doins service/ac_adapter_legion-fancurve
        fi
        
        systemd_enable_service now lenovo-fancurve.service
        systemd_enable_service now lenovo-fancurve-restart.path
        systemd_enable_service now lenovo-fancurve-restart.service
	fi

    echo "CPU Control Feature: On intel cpu install undervolt https://github.com/georgewhewell/undervolt (or other tool you like to use). More information read the readme https://github.com/Petingoso/legion-fan-utils-linux/blob/main/README.md"
}

