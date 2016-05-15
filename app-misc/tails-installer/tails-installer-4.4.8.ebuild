# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils

DESCRIPTION="A graphical tool to install or upgrade Tails on a USB stick from an ISO image"
HOMEPAGE="https://tails.boum.org http://git.tails.boum.org/liveusb-creator"
SRC_URI="http://deb.tails.boum.org/pool/main/t/${PN}/${PN}_${PV}+dfsg.orig.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( ${FILESDIR}/fix-desktop-file.patch ${FILESDIR}/sgdisk.patch )

DEPEND="${PYTHON_DEPS}
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]"
RDEPEND="${PYTHON_DEPS}
	app-arch/p7zip
	dev-libs/glib:2
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/urlgrabber[${PYTHON_USEDEP}]
	sys-apps/gptfdisk
	sys-auth/polkit
	sys-boot/syslinux
	sys-fs/dosfstools
	sys-fs/mtools
	sys-fs/udisks:2[introspection]
	virtual/cdrtools
	x11-libs/gtk+:3[introspection]"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
