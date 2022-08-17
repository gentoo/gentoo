# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=${P/-20/-snapshot-}

DESCRIPTION="GNU Triangulated Surface Library"
HOMEPAGE="http://gts.sourceforge.net/"
SRC_URI="http://gts.sourceforge.net/tarballs/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="test" # bug #277165

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	test? ( media-libs/netpbm )"

PATCHES=( "${FILESDIR}"/${PN}-20121130-autotools.patch )

src_prepare() {
	default

	# fix doc generation (bug #727536)
	sed -i 's/\xe9/\xc3\xa9/;s/\xf6/\xc3\xb6/' src/*.{c,h} || die

	# allow to run tests (bug #277165)
	chmod +x test/*/*.sh || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_compile() {
	default

	if use doc; then
		emake DOC_MAIN_SGML_FILE=gts-docs.xml -C doc html
		HTML_DOCS=( doc/html/. )
	fi
}

src_install() {
	default

	docinto examples
	dodoc examples/*.c

	find "${ED}" -name '*.la' -delete || die
}
