# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools

inherit autotools distutils-r1

DESCRIPTION="Library for International Press Telecommunications Council (IPTC) metadata"
HOMEPAGE="https://github.com/ianw/libiptcdata https://libiptcdata.sourceforge.net/"
SRC_URI="https://github.com/ianw/${PN}/releases/download/release_1_0_5/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc examples nls python"

RDEPEND="
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/gtk-doc-am
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )
	nls? ( >=sys-devel/gettext-0.13.1 )
	python? (
		${DISTUTILS_DEPS}
		${PYTHON_DEPS}
	)
"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	default
	eautoreconf
	if use python; then
		cd python || die
		distutils-r1_src_prepare
	fi
}

src_configure () {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable python)
		$(use_enable doc gtk-doc)
	)
	econf "${myeconfargs[@]}"

	if use python; then
		cd python || die
		distutils-r1_src_configure
	fi
}

src_compile() {
	default
	if use python; then
		cd python || die
		distutils-r1_src_compile
	fi
}

src_install () {
	default

	find "${D}" -name '*.la' -delete || die "failed to remove *.la files"

	if use python; then
		cd python || die
		distutils-r1_src_install
	fi

	if use examples; then
		dodoc python/README
		dodoc -r python/examples
	fi
}
