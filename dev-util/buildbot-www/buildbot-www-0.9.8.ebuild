# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python2_7 python3_5 )

EGIT_REPO_URI="git://github.com/buildbot/buildbot.git"

[[ ${PV} == *9999 ]] && inherit git-r3
inherit distutils-r1

DESCRIPTION="BuildBot base web interface, use with buildbot-{console-view,waterfall-view}..."
HOMEPAGE="http://buildbot.net/ https://github.com/buildbot/buildbot https://pypi.python.org/pypi/buildbot-www"

MY_V="${PV/_p/p}"
MY_P="${PN}-${MY_V}"
[[ ${PV} == *9999 ]] || SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

IUSE="test"

RDEPEND=""

DEPEND="${RDEPEND}
	>=dev-python/setuptools-21.2.1[${PYTHON_USEDEP}]
	~dev-util/buildbot-${PV}[${PYTHON_USEDEP}]
	~dev-util/buildbot-pkg-${PV}[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
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
