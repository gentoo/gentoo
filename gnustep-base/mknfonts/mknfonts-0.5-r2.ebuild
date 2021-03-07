# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnustep-base

DESCRIPTION="A tool to create .nfont packages for use with gnustep-back-art"
HOMEPAGE="https://packages.debian.org/mknfonts.tool"
SRC_URI="mirror://debian/pool/main/m/${PN}.tool/${PN}.tool_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

DEPEND="gnustep-base/gnustep-gui
	>=media-libs/freetype-2.1"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-rename.patch )

src_prepare() {
	# Correct link command for --as-needed
	sed -i -e "s/ADDITIONAL_LDFLAGS/ADDITIONAL_TOOL_LIBS/" GNUmakefile || die "sed failed"

	default
}
