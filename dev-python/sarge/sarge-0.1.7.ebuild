# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="wrapper for subprocess which provides command pipeline functionality"
HOMEPAGE="
	https://docs.red-dove.com/sarge/
	https://pypi.org/project/sarge/
	https://github.com/vsajip/sarge/
"
SRC_URI="
	https://github.com/vsajip/sarge/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

python_test() {
	"${EPYTHON}" test_sarge.py -v || die "Tests failed with ${EPYTHON}"
}
