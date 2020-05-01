# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="http://trac.osgeo.org/geos/"
SRC_URI="http://download.osgeo.org/geos/${PN}-${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="doc ruby static-libs"

BDEPEND="
	doc? ( app-doc/doxygen )
	ruby? ( dev-lang/swig:0 )
"
RDEPEND="
	ruby? ( dev-lang/ruby:* )
"
DEPEND="${RDEPEND}"

RESTRICT="test"

src_prepare() {
	default
	echo "#!${EPREFIX}/bin/bash" > py-compile
}

src_configure() {
	local myeconfargs=(
		--disable-python
		$(use_enable ruby)
		$(use_enable static-libs static)
	)
	use arm && myeconfargs+=( --disable-inline ) # bug 709368

	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use doc && emake -C doc doxygen-html
}

src_install() {
	use doc && local HTML_DOCS=( doc/doxygen_docs/html/. )
	default

	find "${D}" -name '*.la' -type f -delete || die
}
