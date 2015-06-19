# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ruledispatch/ruledispatch-0.5_pre2306-r2.ebuild,v 1.5 2015/04/08 08:05:19 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils versionator flag-o-matic

MY_PN="RuleDispatch"
MY_P="${MY_PN}-$(get_version_component_range 1-2)a0.dev-$(get_version_component_range 3-)"
MY_P="${MY_P/pre/r}"

DESCRIPTION="Rule-based Dispatching and Generic Functions"
HOMEPAGE="http://peak.telecommunity.com/"
# http://svn.eby-sarna.com/RuleDispatch/
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="|| ( PSF-2.4 ZPL )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND=">=dev-python/pyprotocols-1.0_pre2306[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}"

PATCHES=( "${FILESDIR}/${PN}_as_syntax_fix.patch" )

python_configure_all() {
	append-flags -fno-strict-aliasing
}

python_test() {
	cd "${BUILD_DIR}/lib" || die
	# parallel build makes a salad; einfo msg lets us see what's occuring
	for test in dispatch/tests/test_*.py; do
		"${PYTHON}" $test && einfo "Tests $test passed under ${EPYTHON}" \
		|| die "Tests failed under ${EPYTHON}"
	done
	# doctest appears old and unmaintained, left for just in case
	# "${PYTHON}" dispatch/tests/doctest.py
	einfo "Tests passed under ${EPYTHON}"
}
