# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="PowWow Console MUD Client"
HOMEPAGE="https://www.hoopajoo.net/projects/powwow.html"
SRC_URI="https://www.hoopajoo.net/static/projects/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.22-linking.patch
	"${FILESDIR}"/${PN}-1.2.22-musl-termios.patch
)

src_prepare() {
	default

	# note that that the extra, seemingly-redundant files installed are
	# actually used by in-game help commands
	sed -i \
		-e "s/pkgdata_DATA = powwow.doc/pkgdata_DATA = /" \
		Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --includedir="${EPREFIX}"/usr/include
}

src_install() {
	local DOCS=( Hacking powwow.doc powwow.help README.* TODO )
	# Prepend doc/
	DOCS=( ${DOCS[@]/#/doc\//} )
	# Add in the root items
	DOCS+=( ChangeLog NEWS )

	default
}
