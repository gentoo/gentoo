# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="C++ port of the Log for Java (log4j) logging library"
HOMEPAGE="http://log4cplus.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}-stable/${PV}/${P}.tar.bz2"

LICENSE="|| ( Apache-2.0 BSD-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="iconv test threads working-locale working-c-locale qt4"

REQUIRED_USE="iconv? ( !working-locale !working-c-locale )
	working-locale? ( !iconv !working-c-locale )
	working-c-locale? ( !iconv !working-locale )"

RDEPEND="iconv? ( virtual/libiconv )
	qt4? ( dev-qt/qtcore:4 )"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README TODO docs/unicode.txt"

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

src_test() {
	cd tests/

	for dir in appender customloglevel fileappender filter \
		hierarchy loglog ndc ostream patternlayout performance priority \
		propertyconfig timeformat; do
		einfo "Running test \"${dir}_test\""
		pushd "${dir}_test/" 1>/dev/null
		./${dir}_test || die "Running ${dir}_test failed!"
		popd 1>/dev/null
	done

	if use threads; then
		for dir in configandwatch thread; do
			einfo "Running test \"${dir}_test\""
			pushd "${dir}_test/" 1>/dev/null
			./${dir}_test || die "Running ${dir}_test failed!"
			popd 1>/dev/null
		done
	fi
}
