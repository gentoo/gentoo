# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit readme.gentoo

DESCRIPTION="Raspberry PI boot loader and firmware"
HOMEPAGE="https://github.com/raspberrypi/firmware"
MY_PV="1.20160209"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${MY_PV} -> raspberrypi-firmware-${MY_PV}.tar.gz"

LICENSE="GPL-2 raspberrypi-videocore-bin"
SLOT="${PVR}"
KEYWORDS="~arm -*"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/firmware-${MY_PV}

RESTRICT=""

pkg_preinst() {
	if [ -z "${REPLACING_VERSIONS}" ] ; then
		local msg=""
		if [ -e "${D}"/boot/cmdline.txt -a -e "${ROOT}"/boot/cmdline.txt ] ; then
			msg+="/boot/cmdline.txt "
		fi
		if [ -e "${D}"/boot/config.txt -a -e "${ROOT}"/boot/config.txt ] ; then
			msg+="/boot/config.txt "
		fi
		if [ -n "${msg}" ] ; then
			msg="This package installs following files: ${msg}."
			msg="${msg} Please remove(backup) your copies during install"
			msg="${msg} and merge settings afterwards."
			msg="${msg} Further updates will be CONFIG_PROTECTed."
			die "${msg}"
		fi
	fi

	if ! grep "${ROOT}boot" /proc/mounts >/dev/null 2>&1; then
		ewarn "${ROOT}boot is not mounted, the files might not be installed at the right place"
	fi
}

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /lib/modules
	doins -r modules/*
	insinto /boot
	newins boot/kernel.img kernel-${PV}.img
	newins boot/kernel7.img kernel7-${PV}.img

	readme.gentoo_create_doc
}

DOC_CONTENTS="Please configure your ram setup by editing /boot/config.txt"
