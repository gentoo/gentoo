# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

# Can't really call them backports when they're fixes that upstream
# won't carry
FIXES=2

inherit eutils

DESCRIPTION="VGA BIOS implementation"
HOMEPAGE="http://www.nongnu.org/vgabios/"
SRC_URI="https://savannah.gnu.org/download/${PN}/${P}.tgz
	https://dev.gentoo.org/~cardoe/distfiles/${P}-bins.tar.xz
	https://dev.gentoo.org/~cardoe/distfiles/${P}-fixes-${FIXES}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-fbsd"
IUSE="debug"

DEPEND="amd64? ( sys-devel/dev86 )
	x86? ( sys-devel/dev86 )"
RDEPEND=""

src_prepare() {
	[[ -n ${FIXES} ]] && \
		EPATCH_FORCE=yes EPATCH_SUFFIX="patch" EPATCH_SOURCE="${S}/patches" \
			epatch
}

src_compile() {
	if use amd64 || use x86 ; then
		emake clean # Necessary to clean up the pre-built pieces
		emake biossums
		emake
	fi
}

src_install() {
	insinto /usr/share/vgabios

	if use amd64 || use x86 ; then
		# Stock VGABIOS
		newins VGABIOS-lgpl-latest.bin vgabios.bin
		use debug && newins VGABIOS-lgpl-latest.debug.bin vgabios.debug.bin

		# Cirrus
		newins VGABIOS-lgpl-latest.cirrus.bin vgabios-cirrus.bin
		use debug && newins VGABIOS-lgpl-latest.cirrus.debug.bin \
			vgabios-cirrus.debug.bin

		# QXL
		newins VGABIOS-lgpl-latest.qxl.bin vgabios-qxl.bin
		use debug && newins VGABIOS-lgpl-latest.qxl.debug.bin \
			vgabios-qxl.debug.bin

		# Standard VGA
		newins VGABIOS-lgpl-latest.stdvga.bin vgabios-stdvga.bin
		use debug && newins VGABIOS-lgpl-latest.stdvga.debug.bin \
			vgabios-stdvga.debug.bin

		# VMWare
		newins VGABIOS-lgpl-latest.vmware.bin vgabios-vmware.bin
		use debug && newins VGABIOS-lgpl-latest.vmware.debug.bin \
			vgabios-vmware.debug.bin
	else
		doins bins/*
	fi
}
