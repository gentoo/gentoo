# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

MY_PN="PyICU"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for dev-libs/icu"
HOMEPAGE="https://github.com/ovalhub/pyicu"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	dev-libs/icu:="
DEPEND="${RDEPEND}
	test? ( dev-python/pytest
		dev-python/six )"

S="${WORKDIR}/${MY_P}"

DOCS=(CHANGES CREDITS README.md)

# This will no longer be necessary in the next release
PATCHES=( "${FILESDIR}"/${PN}-2.3.1-testSurrogatePairs_workaround.patch )

python_test() {
	esetup.py test
}
