# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="A realistic password strength estimator"
HOMEPAGE="https://github.com/dwolfhub/zxcvbn-python"
SRC_URI="
	https://github.com/dwolfhub/zxcvbn-python/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
S=${WORKDIR}/zxcvbn-python-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"

distutils_enable_tests pytest
