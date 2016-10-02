# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="C++ port of the Log for Java (log4j) logging library"
HOMEPAGE="http://log4cplus.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}-stable/${PV}/${P}.tar.bz2"

LICENSE="|| ( Apache-2.0 BSD-2 )"
SLOT="0/1.2-5"
KEYWORDS="~amd64 ~x86"
IUSE="iconv qt4 threads working-locale working-c-locale"
REQUIRED_USE="?? ( iconv working-locale working-c-locale )"

RDEPEND="iconv? ( virtual/libiconv )
	qt4? ( dev-qt/qtcore:4 )"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.2.0-fix-c++14.patch" )

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
	cd tests/ || die

	local t
	for t in appender customloglevel fileappender filter \
	 hierarchy loglog ndc ostream patternlayout performance priority \
	 propertyconfig timeformat; do
		einfo "Running test \"${t}_test\""
		pushd "${t}_test/" >/dev/null || die
		"${S}"/${t}_test || die "Running ${t}_test failed!"
		popd >/dev/null || die
	done

	if use threads; then
		for t in configandwatch thread; do
			einfo "Running test \"${t}_test\""
			pushd "${t}_test/" >/dev/null || die
			"${S}"/${t}_test || die "Running ${t}_test failed!"
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
