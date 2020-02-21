# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

EGIT_COMMIT="fcf71a89265c78fc26243574dda3a872574a5c02"
DESCRIPTION="Recompress ZIP, PNG and MNG, considerably improving compression"
HOMEPAGE="https://www.advancemame.it/comp-readme.html"
SRC_URI="https://github.com/amadvance/advancecomp/archive/${EGIT_COMMIT}.tar.gz
	-> ${PN}-${EGIT_COMMIT}.tar.gz"

LICENSE="GPL-2+ Apache-2.0 LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ppc ppc64 x86"
IUSE=""

RDEPEND="app-arch/bzip2:=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

# Tests seem to rely on exact output:
# https://sourceforge.net/p/advancemame/bugs/270/
RESTRICT="test"

S=${WORKDIR}/${PN}-${EGIT_COMMIT}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--enable-bzip2
		# (--disable-* arguments are mishandled)
		# --disable-debug
		# --disable-valgrind
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	dodoc HISTORY
}
