# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="OO-DBMS with interfaces for C/C++/Java/PHP/Perl"
HOMEPAGE="http://www.garret.ru/~knizhnik/gigabase.html"
SRC_URI="mirror://sourceforge/gigabase/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${P}-fix-dereferencing.patch"
	"${FILESDIR}/${P}-cpp14.patch" # fix #594550
	"${FILESDIR}/${P}-fix-build-system.patch"
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	default

	if use doc; then
		doxygen doxygen.cfg || die
		HTML_DOCS=( GigaBASE.htm docs/html/. )
	fi
}

src_test() {
	local t
	for t in testddl testidx testidx2 testiref testleak testperf \
	 testperf2 testspat testtl testsync testtimeseries; do
		./${t} || die
	done
}

src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}

pkg_postinst() {
	elog "The subsql binary has been renamed to subsql-gdb,"
	elog "to avoid a name clash with the FastDB version of subsql"
}
