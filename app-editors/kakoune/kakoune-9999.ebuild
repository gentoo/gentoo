# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic toolchain-funcs git-r3 versionator

DESCRIPTION="Selection-oriented code editor inspired by vim"
HOMEPAGE="https://github.com/mawww/kakoune"
EGIT_REPO_URI="https://github.com/mawww/kakoune.git"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS=""
IUSE="debug static"

RDEPEND="
	sys-libs/ncurses:0=[unicode]
	dev-libs/boost:=
"
DEPEND="
	app-text/asciidoc
	virtual/pkgconfig
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-0_pre20161111-makefile.patch" )

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if tc-is-gcc && ! version_is_at_least 5.0 $(gcc-version); then
			die "Clang or GCC >=5.0 is required to build this version"
		fi
	fi
}

src_configure() {
	append-cppflags $($(tc-getPKG_CONFIG) --cflags ncursesw)
	append-libs $($(tc-getPKG_CONFIG) --libs ncursesw)
	tc-export CXX
	export debug=$(usex debug)
	export static=$(usex static)
}

src_install() {
	emake -C src DESTDIR="${D}" PREFIX="${EPREFIX}/usr" docdir="${ED%/}/usr/share/doc/${PF}" install
}
