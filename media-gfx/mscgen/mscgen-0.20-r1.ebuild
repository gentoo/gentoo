# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Message sequence chart generator"
HOMEPAGE="https://www.mcternan.me.uk/mscgen/"
SRC_URI="https://www.mcternan.me.uk/${PN}/software/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~x64-solaris"
IUSE="png truetype test"
RESTRICT="!test? ( test )"
# bug #379279
REQUIRED_USE="
	truetype? ( png )
	test? ( png )
"

RDEPEND="
	truetype? ( media-libs/freetype )
	png? ( media-libs/gd[png,truetype?] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.20-escape.patch
	"${FILESDIR}"/${PN}-0.20-uninitialized-ymax.patch
	"${FILESDIR}"/${PN}-0.20-language.patch
	"${FILESDIR}"/${PN}-0.20-width-never-less-than-zero.patch
)

src_prepare() {
	default
	sed -i -e '/dist_doc_DATA/d' Makefile.am || die "Fixing Makefile.am failed"
	eautoreconf
}

src_configure() {
	local myconf=()

	if use png; then
		use truetype && myconf+=( --with-freetype )
	else
		myconf+=( --without-png )
	fi

	econf "${myconf[@]}"
}
