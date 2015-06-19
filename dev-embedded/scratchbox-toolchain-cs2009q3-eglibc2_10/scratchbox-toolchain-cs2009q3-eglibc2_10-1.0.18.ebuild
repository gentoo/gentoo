# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/scratchbox-toolchain-cs2009q3-eglibc2_10/scratchbox-toolchain-cs2009q3-eglibc2_10-1.0.18.ebuild,v 1.2 2014/08/10 20:06:01 slyfox Exp $

ARMHARDV="hard-${PV}-4"
ARMSOFTV="soft-${PV}-5"
I486V="1.0.17-3"

DESCRIPTION="A cross-compilation toolkit designed to make embedded Linux application development easier"
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="http://scratchbox.org/download/files/sbox-releases/hathor/tarball/${PN/_/.}-armv7-${ARMHARDV}-i386.tar.gz
	http://scratchbox.org/download/files/sbox-releases/hathor/tarball/${PN/_/.}-armv7-${ARMSOFTV}-i386.tar.gz
	http://scratchbox.org/download/files/sbox-releases/hathor/tarball/${PN/_/.}-i486-${I486V}-i386.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Stripping BREAKS scratchbox, it runs in a chroot and is pre-stripped when needed (bug #296294)
RESTRICT="strip"

DEPEND=""
RDEPEND="=dev-embedded/scratchbox-1.0*"

TARGET_DIR="/opt/scratchbox"

S=${WORKDIR}/scratchbox

src_install() {
	dodir ${TARGET_DIR}
	cp -pRP * "${D}/${TARGET_DIR}"
}
