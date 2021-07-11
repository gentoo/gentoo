# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

MY_PV="${PV/_p/.post}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="BuildBot common www build tools for packaging releases"
HOMEPAGE="https://buildbot.net/ https://github.com/buildbot/buildbot https://pypi.org/project/buildbot-pkg/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~arm64 ~amd64-linux ~x86-linux"

# No real integration tests for this pkg.
# all tests are related to making releases and final checks for distribution

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	sed -e "s:version=buildbot_pkg.getVersion(\".\"),:version=\"${MY_PV}\",:" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
