# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/scratchbox-toolchain-cs2005q3_2-glibc2_5/scratchbox-toolchain-cs2005q3_2-glibc2_5-1.0.7.ebuild,v 1.6 2014/08/10 20:05:33 slyfox Exp $

SBOX_GROUP="sbox"

ARMV=${PV}
I386V=${PV}.2

DESCRIPTION="A cross-compilation toolkit designed to make embedded Linux application development easier"
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="http://scratchbox.org/download/files/sbox-releases/stable/tarball/${PN/cs2005q3_2-glibc2_5/cs2005q3.2-glibc2.5}-arm-${PV}.2-i386.tar.gz
	http://scratchbox.org/download/files/sbox-releases/stable/tarball/${PN/cs2005q3_2-glibc2_5/cs2005q3.2-glibc2.5}-i386-${PV}-i386.tar.gz"
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
