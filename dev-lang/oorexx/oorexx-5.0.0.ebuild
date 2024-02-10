# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_REVISION=12583

inherit cmake

DESCRIPTION="Open source implementation of Object Rexx"
HOMEPAGE="https://www.oorexx.org/about.html
	https://sourceforge.net/projects/oorexx/"
SRC_URI="https://sourceforge.net/projects/${PN}/files/${PN}/${PV}/${P}-${APP_REVISION}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-libs/ncurses:=
	virtual/libcrypt:=
"
DEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-5.0.0-man.patch" )

src_unpack() {
	default

	# HACK: Dance around cmake.eclass S directory requirements.
	mv "${WORKDIR}" "${T}/${P}" || die
	mkdir -p "${WORKDIR}" || die
	mv "${T}/${P}" "${S}" || die
}
