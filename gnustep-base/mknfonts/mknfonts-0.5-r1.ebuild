# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils gnustep-base

DESCRIPTION="A tool to create .nfont packages for use with gnustep-back-art"

HOMEPAGE="http://packages.debian.org/mknfonts.tool"
SRC_URI="mirror://debian/pool/main/m/${PN}.tool/${PN}.tool_${PV}.orig.tar.gz"
KEYWORDS="~alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="gnustep-base/gnustep-gui
	>=media-libs/freetype-2.1"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Correct link command for --as-needed
	sed -i -e "s/ADDITIONAL_LDFLAGS/ADDITIONAL_TOOL_LIBS/" GNUmakefile || die "sed failed"
	epatch "${FILESDIR}"/${PN}-rename.patch
}
