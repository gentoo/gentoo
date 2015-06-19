# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/scratchbox-devkit-maemo3/scratchbox-devkit-maemo3-1.0.3.ebuild,v 1.7 2014/08/10 20:05:05 slyfox Exp $

SBOX_GROUP="sbox"

DESCRIPTION="A cross-compilation toolkit designed to make embedded Linux application development easier"
HOMEPAGE="http://www.scratchbox.org/"
SRC_URI="http://scratchbox.org/download/files/sbox-releases/stable/tarball/${P}-i386.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Stripping BREAKS scratchbox, it runs in a chroot and is pre-stripped when needed (bug #296294)
RESTRICT="strip"

RDEPEND="=dev-embedded/scratchbox-1.0*"
DEPEND=""

QA_TEXTRELS="opt/scratchbox"
QA_EXECSTACK="opt/scratchbox"

TARGET_DIR="/opt/scratchbox"

S=${WORKDIR}/scratchbox

src_install() {
	dodir ${TARGET_DIR}
	cp -pRP * "${D}/${TARGET_DIR}"
}
