# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A realistic password strength estimator"
HOMEPAGE="
	https://github.com/dwolfhub/zxcvbn-python/
	https://pypi.org/project/zxcvbn/
"
SRC_URI="
	https://github.com/dwolfhub/zxcvbn-python/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/zxcvbn-python-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

distutils_enable_tests pytest
