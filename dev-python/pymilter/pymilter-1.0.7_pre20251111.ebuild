# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/sdgathman/pymilter.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	if [[ ${PV} == *_pre* ]]; then
		SRC_URI="https://dev.gentoo.org/~eras/distfiles/${P}.tar.xz"
		S="${WORKDIR}/pymilter"
	else
		inherit pypi
	fi
fi

DESCRIPTION="module to enable python scripts to attach to Sendmail's libmilter API"
HOMEPAGE="https://www.pymilter.org/"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	mail-filter/libmilter:=
"

distutils_enable_tests unittest

src_test() {
	# requires berkeleydb and bsddb3 modules
	sed -i -e "/s.addTest(testpolicy.suite())/d" \
		-e "/import testpolicy/d" test.py || die
	rm testpolicy.py
	distutils-r1_src_test
}
