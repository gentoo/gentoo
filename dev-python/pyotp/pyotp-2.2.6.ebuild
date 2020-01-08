# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="PyOTP is a Python library for generating and verifying one-time passwords."
HOMEPAGE="https://github.com/pyotp/pyotp https://pypi.org/project/pyotp/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Testing failed with ${EPYTHON}"
}
