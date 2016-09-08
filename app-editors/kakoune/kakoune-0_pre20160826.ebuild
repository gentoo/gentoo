# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs vcs-snapshot versionator

REF="9124851029700026bc937c81da829fbadcc5b29d"

DESCRIPTION="Selection-oriented code editor inspired by vim"
HOMEPAGE="https://github.com/mawww/kakoune"
SRC_URI="https://github.com/mawww/${PN}/tarball/${REF} -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	sys-libs/ncurses:=[unicode]
	dev-libs/boost:=
"
DEPEND="
	app-text/asciidoc
	virtual/pkgconfig
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-makefile.patch" )

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if tc-is-gcc && ! version_is_at_least 5.0 $(gcc-version); then
			die "Clang or GCC >=5.0 is required to build this version"
		fi
	fi
}

src_configure() {
	append-cppflags $($(tc-getPKG_CONFIG) --cflags ncursesw)
	append-libs $($(tc-getPKG_CONFIG) --libs ncursesw)
	export CXX=$(tc-getCXX)
	export debug=$(usex debug)
	S="${WORKDIR}/${P}/src"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" docdir="${D}/usr/share/doc/${PF}" install
}
