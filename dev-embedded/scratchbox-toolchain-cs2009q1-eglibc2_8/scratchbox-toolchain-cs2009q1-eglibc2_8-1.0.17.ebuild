# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/scratchbox-toolchain-cs2009q1-eglibc2_8/scratchbox-toolchain-cs2009q1-eglibc2_8-1.0.17.ebuild,v 1.2 2014/08/10 20:05:54 slyfox Exp $

ARMV=${PV}-10
I486V=${PV}-5

DESCRIPTION="A cross-compilation toolkit designed to make embedded Linux application development easier"
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="http://scratchbox.org/download/files/sbox-releases/hathor/tarball/${PN/_/.}-armv7-${ARMV}-i386.tar.gz
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
