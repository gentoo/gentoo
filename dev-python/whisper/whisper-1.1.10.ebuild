# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Fixed size round-robin style database"
HOMEPAGE="
	https://github.com/graphite-project/whisper/
	https://pypi.org/project/whisper/
"
SRC_URI="
	https://github.com/graphite-project/whisper/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x TZ=UTC
	epytest
}
