# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

MY_PN="trrntzip"
MY_PV="code-9"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Advanced archiver to create identical files over multiple systems"
HOMEPAGE="https://sourceforge.net/projects/trrntzip"
SRC_URI="http://sourceforge.net/code-snapshots/svn/t/tr/${MY_PN}/code/${MY_P}.zip -> ${P}.zip"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
DEPEND="sys-libs/zlib"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-fix-function-declarations.patch"
)

src_prepare() {
	# Source-code from sf.net snapshots has CRLF...
	EPATCH_OPTS="--binary"

	epatch "${PATCHES[@]}"

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	nonfatal dodoc README AUTHORS
}
