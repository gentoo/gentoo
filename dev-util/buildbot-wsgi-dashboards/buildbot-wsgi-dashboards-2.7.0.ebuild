# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_6 )

EGIT_REPO_URI="https://github.com/buildbot/buildbot.git"

DISTUTILS_USE_SETUPTOOLS="rdepend"

[[ ${PV} == *9999 ]] && inherit git-r3
inherit distutils-r1

DESCRIPTION="Buildbot plugin to integrate flask or bottle dashboards to buildbot UI"
HOMEPAGE="https://buildbot.net/ https://github.com/buildbot/buildbot https://pypi.org/project/buildbot-wsgi-dashboards/"

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

RDEPEND=""

DEPEND="${RDEPEND}
	>=dev-python/setuptools-21.2.1[${PYTHON_USEDEP}]
	~dev-util/buildbot-${PV}[${PYTHON_USEDEP}]
	~dev-util/buildbot-www-${PV}[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"
#[[ ${PV} == *9999 ]] && S=${S}/www/base
