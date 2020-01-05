# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ConfigArgParse"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for argparse supporting config files and env variables"
HOMEPAGE="https://github.com/zorro3/ConfigArgParse https://pypi.org/project/ConfigArgParse/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

python_test() {
	"${PYTHON}" tests/test_configargparse.py || die
}
