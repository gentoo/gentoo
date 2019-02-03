# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

MY_PN="PyICU"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for dev-libs/icu"
HOMEPAGE="https://github.com/ovalhub/pyicu"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="${PYTHON_DEPS}
	dev-libs/icu"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest
		dev-python/six )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_P}"

DOCS=(CHANGES CREDITS README.md)

python_test() {
	if [[ ${EPYTHON} == python2* ]]; then
		# See Bug #644226
		ewarn "Skipping tests for ${EPYTHON} because they are known to fail"
	else
		esetup.py test
	fi
}
