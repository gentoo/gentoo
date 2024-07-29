# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

MY_PV=${PV//./}

DESCRIPTION="Linux/390 Interface to z/VM's Control Program"
HOMEPAGE="http://linuxvm.org/Patches/index.html"
SRC_URI="http://linuxvm.org/Patches/s390/${PN}${MY_PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~s390"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-prototypes.patch
	"${FILESDIR}"/${P}-kernel.patch
)

src_prepare() {
	default

	# the makefile uses this variable
	export KERNEL_DIR
}

src_install() {
	emake install prefix="${D}"
	dodoc ChangeLog HOW-TO
}
