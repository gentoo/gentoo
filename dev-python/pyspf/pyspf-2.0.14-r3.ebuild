# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="ipv6(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python implementation of the Sender Policy Framework (SPF)"
HOMEPAGE="
	https://github.com/sdgathman/pyspf/
	https://pypi.org/project/pyspf/
"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/authres[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		${RDEPEND}
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

python_test() {
	cd test || die
	"${EPYTHON}" testspf.py || die "Test fail with ${EPYTHON}"
}
