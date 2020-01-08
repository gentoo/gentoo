# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python2_7 python3_6 )

EGIT_REPO_URI="https://github.com/buildbot/buildbot.git"

[[ ${PV} == *9999 ]] && inherit git-r3
inherit distutils-r1

DESCRIPTION="BuildBot grid view web interface"
HOMEPAGE="https://buildbot.net/ https://github.com/buildbot/buildbot https://pypi.org/project/buildbot-grid-view/"

MY_PV="${PV/_p/.post}"
MY_P="${PN}-${MY_PV}"
[[ ${PV} == *9999 ]] || SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""

DEPEND="${RDEPEND}
	>=dev-python/setuptools-21.2.1[${PYTHON_USEDEP}]
	=dev-util/buildbot-0.9.12*[${PYTHON_USEDEP}]
	=dev-util/buildbot-www-0.9.12*[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"
#[[ ${PV} == *9999 ]] && S=${S}/www/base

python_test() {
	distutils_install_for_testing

	esetup.py test || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
}
