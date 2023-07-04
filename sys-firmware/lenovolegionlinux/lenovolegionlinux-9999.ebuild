# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

EPYTHON=python3

inherit linux-mod-r1 toolchain-funcs git-r3 distutils-r1 desktop systemd

EGIT_REPO_URI="https://github.com/johnfanv2/LenovoLegionLinux.git"

DESCRIPTION="Lenovo Legion Linux kernel module"
HOMEPAGE="https://github.com/johnfanv2/LenovoLegionLinux"

DEPEND="sys-kernel/linux-headers
        sys-apps/lm-sensors
        sys-apps/dmidecode
        legion-tools? ( dev-python/PyQt5 )
        legion-tools? ( dev-python/pyyaml )
        legion-tools? ( dev-python/argcomplete )
		app-portage/smart-live-rebuild
		acpi? ( sys-power/acpid )
		radeon-dgpu? ( dev-util/rocm-smi )
        downgrade-nvidia? ( <=x11-drivers/nvidia-drivers-525 )
        app-portage/smart-live-rebuild
        ryzenadj? ( sys-power/RyzenAdj )"
LICENSE="GPL-2"
SLOT="0"
IUSE="legion-tools acpi systemd radeon-dgpu downgrade-nvidia ryzenadj"
REQUIRED_USE="|| ( systemd acpi radeon-dgpu downgrade-nvidia ryzenadj legion-tools ) acpi? ( legion-tools ) radeon-dgpu? ( !downgrade-nvidia legion-tools ) downgrade-nvidia? ( !radeon-dgpu legion-tools )"

MODULES_KERNEL_MIN=5.10

src_compile() {
	local modlist=(
		legion-laptop=kernel/drivers/platform/x86:kernel_module:kernel_module:all
	)
    KERNELVERSION=${KV_FULL} linux-mod-r1_src_compile
	if use legion-tools; then
		#Define build dir (fix sandboxed)
		cd "${WORKDIR}/${P}/python/legion_linux"
		distutils-r1_src_compile --build-dir "${WORKDIR}/${P}/python/legion_linux/build"
	fi
}

src_install() {
	linux-mod-r1_src_install
	#Load the module without reboot
	cd "${WORKDIR}/${P}/python/legion_linux/"
	make forcereloadmodule
	if use legion-tools; then
		#Define build dir (fix sandboxed)
		cd "${WORKDIR}/${P}/python/legion_linux/"
		distutils-r1_src_install --build-dir "${WORKDIR}/${P}/python/legion_linux/build"

		cd "${WORKDIR}/${P}/extra"

		if use acpi; then
            insinto /etc/acpi/events/ && doins acpi/events/{ac_adapter_legion-fancurve,novo-button,PrtSc-button,fn-r-refrate}
			insinto /etc/acpi/actions/ && doins acpi/actions/{battery-legion-quiet.sh,snipping-tool.sh,fn-r-refresh-rate.sh}
        fi

		if use systemd; then
        	systemd_dounit service/legion-linux.service service/legion-linux.path
			dobin service/fancurve-set
			insinto /usr/share/legion_linux && doins service/profiles/*
			insinto /etc/legion_linux && doins service/profiles/*

			#AMD
    		if use radeon-dgpu; then
        		insinto /usr/share/legion_linux && newins "${FILESDIR}/radeon" .env
				insinto /etc/legion_linux && newins "${FILESDIR}/radeon" .env
    		fi
    		#NVIDIA (need dowgrade because nvidia-smi -pl was removed)
   			 if use downgrade-nvidia; then 
        		insinto /usr/share/legion_linux && newins "${FILESDIR}/nvidia" .env
				insinto /etc/legion_linux && newins "${FILESDIR}/nvidia" .env
    		fi

			if use ryzenadj; then 
        		insinto /usr/share/legion_linux && newins "${FILESDIR}/cpu" .env
				insinto /etc/legion_linux && newins "${FILESDIR}/cpu" .env
    		fi

			elog  "IMPORTANT!!!!\nPls copy /usr/share/legion_linux folder to .config in your Home folder\n Dont forget to edit .config/legion_linux/.env"
		fi

		# Desktop Files and Polkit
		domenu "${FILESDIR}/legion_gui.desktop"
		doicon "${WORKDIR}/${P}/python/legion_linux/legion_linux/legion_logo.png"
		insinto "/usr/share/polkit-1/actions/" && doins "${FILESDIR}/legion_cli.policy"

	fi

	elog "INTEL USERS!!!!\nCPU Control Feature: On intel cpu install undervolt https://github.com/georgewhewell/undervolt (or other tool you like to use). More information read the readme https://github.com/Petingoso/legion-fan-utils-linux/blob/main/README.md"
}

