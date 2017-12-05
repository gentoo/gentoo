# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

SBOX_GROUP="sbox"

DESCRIPTION="A cross-compilation toolkit for embedded Linux application development"
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="http://scratchbox.org/download/files/sbox-releases/hathor/tarball/${P}-i386.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Stripping BREAKS scratchbox, it runs in a chroot and is pre-stripped when needed (bug #296294)
RESTRICT="strip"

RDEPEND="=dev-embedded/scratchbox-1.0*"
DEPEND=""

TARGET_DIR="/opt/scratchbox"

QA_TEXTRELS="opt/scratchbox"

S=${WORKDIR}/scratchbox

src_install() {
	dodir ${TARGET_DIR}
	cp -pRP * "${D}/${TARGET_DIR}"
}
