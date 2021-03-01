# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="https://trac.osgeo.org/geos/"

# Arrow can be removed at next version bump. Upstream mistakenly
# released rc1 as 3.9.0. So, we need(ed) a new Manifest entry to get the
# real 3.9.0
SRC_URI="https://download.osgeo.org/geos/${PN}-${PV}.tar.bz2 -> ${PN}-${PV}-r1.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="doc static-libs"

BDEPEND="doc? ( app-doc/doxygen )"

RESTRICT="test"

src_configure() {
	local myeconfargs=(	$(use_enable static-libs static) )
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
