# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
PYTHON_REQ_USE="ipv6?"

DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="Python implementation of the Sender Policy Framework (SPF)"
HOMEPAGE="https://pypi.org/project/pyspf/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ipv6 test"
REQUIRED_USE="test? ( ipv6 )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/authres[${PYTHON_USEDEP}]
	|| (
		dev-python/pydns:3[${PYTHON_USEDEP}]
		dev-python/dnspython[${PYTHON_USEDEP}]
	)
"

DEPEND="
	test? (
		${RDEPEND}
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

python_test() {
	pushd test &> /dev/null || die
	"${PYTHON}" testspf.py || die
	popd &> /dev/null || die
}
