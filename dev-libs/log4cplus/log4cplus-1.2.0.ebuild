# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="C++ port of the Log for Java (log4j) logging library"
HOMEPAGE="http://log4cplus.sourceforge.net/ https://github.com/log4cplus/log4cplus"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}-stable/${PV}/${P}.tar.bz2"

LICENSE="|| ( Apache-2.0 BSD-2 )"
SLOT="0/1.2-5"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="iconv qt5 threads working-locale working-c-locale"
REQUIRED_USE="?? ( iconv working-locale working-c-locale )"

RDEPEND="
	iconv? ( virtual/libiconv )
	qt5? ( dev-qt/qtcore:5 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${PN}-1.2.0-fix-c++14.patch" )

src_configure() {
	# bug 648714
	# Qt5 now requires C++11
	append-cxxflags -std=c++11

	econf \
		--disable-static \
		$(use_with iconv) \
		$(use_with qt5) \
		$(use_enable threads) \
		$(use_with working-locale) \
		$(use_with working-c-locale)
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
