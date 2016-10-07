# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="git://github.com/buildbot/buildbot.git"

[[ ${PV} == *9999 ]] && inherit git-r3
inherit distutils-r1

MY_V="0.9.0.post1"
MY_P="${PN}-${MY_V}"

DESCRIPTION="BuildBot common www build tools for packaging releases"
HOMEPAGE="http://trac.buildbot.net/ https://github.com/buildbot/buildbot http://pypi.python.org/pypi/buildbot"
[[ ${PV} == *9999 ]] || SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

if [[ ${PV} == *9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
fi

RDEPEND="
	~dev-util/buildbot-${PV}[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	>=dev-python/setuptools-21.2.1[${PYTHON_USEDEP}]
"

S=${WORKDIR}/${MY_P}

python_install_all() {
	distutils-r1_python_install_all
}
