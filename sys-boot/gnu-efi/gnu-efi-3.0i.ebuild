# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P="${PN}_${PV}"
DESCRIPTION="Library for build EFI Applications"
HOMEPAGE="http://developer.intel.com/technology/efi"
SRC_URI="mirror://sourceforge/gnu-efi/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/g/gnu-efi/gnu-efi_3.0i-2.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ia64 ~x86"
IUSE=""

DEPEND="sys-apps/pciutils"

src_unpack() {
	unpack ${A}
	cd "${S}"
	EPATCH_OPTS="-p1" epatch "${WORKDIR}"/*.diff
}

src_compile() {
	local iarch
	case $ARCH in
		ia64)  iarch=ia64 ;;
		x86)   iarch=ia32 ;;
		amd64) iarch=x86_64 ;;
		*)     die "unknown architecture: $ARCH" ;;
	esac
	# The lib subdir uses unsafe archive targets, and
	# the apps subdir needs gnuefi subdir
	emake prefix=${CHOST}- ARCH=${iarch} -j1 || die
}

src_install() {
	emake install INSTALLROOT="${D}"/usr || die
	dodoc README* ChangeLog
}
