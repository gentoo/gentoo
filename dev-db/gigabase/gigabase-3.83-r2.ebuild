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
)

HTML_DOCS=( GigaBASE.htm docs/html/. )

src_configure() {
	econf $(use_enable static-libs static)
	sed -r -i -e 's/subsql([^\.]|$)/subsql-gdb\1/' Makefile || die
}

src_compile() {
	emake
	if use doc; then
		doxygen doxygen.cfg || die
	fi
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

src_test() {
	pwd
	cd "${S}"
	local TESTS
	TESTS="testddl testidx testidx2 testiref testleak testperf testperf2 testspat testtl testsync testtimeseries"

	local t
	for t in ${TESTS}; do
		./${t} || die
	done
}

pkg_postinst() {
	elog "The subsql binary has been renamed to subsql-gdb,"
	elog "to avoid a name clash with the FastDB version of subsql"
}
