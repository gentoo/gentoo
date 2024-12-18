# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_REVISION="12583"

inherit cmake flag-o-matic

DESCRIPTION="Open source implementation of Object Rexx"
HOMEPAGE="https://www.oorexx.org/about.html
	https://sourceforge.net/projects/oorexx/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}-${APP_REVISION}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 ~riscv ~x86"

RDEPEND="
	sys-libs/ncurses:=
	virtual/libcrypt:=
	!dev-lang/regina-rexx
"
DEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-5.0.0-man.patch" )

src_unpack() {
	default

	# HACK: Dance around cmake.eclass S directory requirements.
	# > * QA notice: S=WORKDIR is deprecated for cmake.eclass.
	# > * Please relocate the sources in src_unpack.
	mv "${WORKDIR}" "${T}/${P}" || die
	mkdir -p "${WORKDIR}" || die
	mv "${T}/${P}" "${S}" || die
}

src_configure() {
	# bug 924171
	if use elibc_musl ; then
		append-cppflags -D_LARGEFILE64_SOURCE
	fi

	cmake_src_configure
}
