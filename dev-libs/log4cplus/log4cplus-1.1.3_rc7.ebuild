# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="${P/_/-}"

DESCRIPTION="C++ port of the Log for Java (log4j) logging library"
HOMEPAGE="http://log4cplus.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}-stable/${PV%_*}/${MY_P}.tar.bz2"

LICENSE="|| ( Apache-2.0 BSD-2 )"
SLOT="0/1.1-9"
KEYWORDS="~amd64 ~x86"
IUSE="iconv test threads working-locale working-c-locale qt4"
REQUIRED_USE="?? ( iconv working-locale working-c-locale )"

RDEPEND="iconv? ( virtual/libiconv )
	qt4? ( dev-qt/qtcore:4 )"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	if ! use test; then
		sed -i -e 's:tests::' Makefile.in || die
	fi
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable threads) \
		$(use_with iconv) \
		$(use_with working-locale) \
		$(use_with working-c-locale) \
		$(use_with qt4 qt)
}

src_compile() {
	default
	use test && emake -C tests
}

src_test() {
	cd tests/ || die

	local t
	for t in appender customloglevel fileappender filter \
	 hierarchy loglog ndc ostream patternlayout performance priority \
	 propertyconfig timeformat; do
		einfo "Running test \"${t}_test\""
		pushd "${t}_test/" >/dev/null || die
		./${t}_test || die "Running ${t}_test failed!"
		popd >/dev/null || die
	done

	if use threads; then
		for t in configandwatch thread; do
			einfo "Running test \"${t}_test\""
			pushd "${t}_test/" >/dev/null || die
			./${t}_test || die "Running ${t}_test failed!"
			popd >/dev/null || die
		done
	fi
}

src_install() {
	default
	dodoc docs/unicode.txt

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
