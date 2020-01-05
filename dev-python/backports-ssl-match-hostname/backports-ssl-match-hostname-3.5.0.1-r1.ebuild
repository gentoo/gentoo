# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
# This is a backport from python3.5+
# Do not add python3.5 or later support here, there's no need for it.
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN/-/.}
MY_PN=${MY_PN//-/_}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Backport of the ssl.match_hostname function"
HOMEPAGE="https://pypi.org/project/backports.ssl_match_hostname/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="PYTHON"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/backports[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

python_install_all() {
	local DOCS=( backports/ssl_match_hostname/README.txt )
	distutils-r1_python_install_all
}

python_install() {
	# main namespace provided by dev-python/backports
	rm "${BUILD_DIR}"/lib/backports/__init__.py || die
	distutils-r1_python_install --skip-build
}
