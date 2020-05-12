# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python language binding for Selenium Remote Control"
HOMEPAGE="http://www.seleniumhq.org"
# pypi tarball misses tests, github tarball misses generated files
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? (
		https://github.com/SeleniumHQ/selenium/archive/${P}.tar.gz
			-> ${P}.gh.tar.gz
	)"

KEYWORDS="amd64 arm ~arm64 ~ia64 ~ppc ppc64 ~sparc x86"
LICENSE="Apache-2.0"
SLOT="0"

DOCS=( CHANGES README.rst )

QA_PREBUILT="/usr/lib*/python*/site-packages/${PN}/webdriver/firefox/*/x_ignore_nofocus.so"

distutils_enable_tests pytest

src_unpack() {
	unpack "${P}.tar.gz"
	if use test; then
		cd "${S}" || die
		ebegin "Unpacking tests from ${P}.gh.tar.gz"
		tar -x -z -f "${DISTDIR}/${P}.gh.tar.gz" --strip-components 2 \
			"${PN}-${P}"/py/test
		eend ${?} || die
	fi
}

python_test() {
	pytest -vv test/unit || die "Tests fail with ${EPYTHON}"
}
