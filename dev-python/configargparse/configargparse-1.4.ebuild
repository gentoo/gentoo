# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_PN="ConfigArgParse"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Drop-in replacement for argparse supporting config files and env variables"
HOMEPAGE="
	https://github.com/bw2/ConfigArgParse/
	https://pypi.org/project/ConfigArgParse/"
SRC_URI="
	https://github.com/bw2/ConfigArgParse/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-python/pyyaml[${PYTHON_USEDEP}] )"

python_test() {
	local -x COLUMNS=80
	esetup.py test
}
