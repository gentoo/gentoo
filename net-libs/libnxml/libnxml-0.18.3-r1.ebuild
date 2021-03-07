# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A C-library for parsing and writing XML 1.0/1.1 files or streams"
HOMEPAGE="https://www.autistici.org/bakunin/libnxml/doc/"
SRC_URI="https://www.autistici.org/bakunin/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc ~sparc x86"
IUSE="doc examples"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default

	# Fix lib dir in installed pkgconfig file
	sed -i -e "s:\${exec_prefix}/lib:\${exec_prefix}/$(get_libdir):" nxml.pc.in \
		|| die "Failed to correct pkgconfig file"
}

src_configure() {
	econf --disable-static
}

src_compile() {
	default

	if use doc; then
		ebegin "Creating documentation"
		doxygen doxy.conf || die "generating docs failed"
		# clean out doxygen gunk
		rm doc/html/*.{md5,map} || die
		HTML_DOCS=( doc/html/. )
		eend 0
	fi
}

src_install() {
	default

	if use examples; then
		docinto test
		dodoc test/*.c
	fi

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
