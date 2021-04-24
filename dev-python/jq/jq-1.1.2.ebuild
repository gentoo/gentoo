# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Python bindings for jq"
HOMEPAGE="https://github.com/mwilliamson/jq.py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz
	https://github.com/kkos/oniguruma/releases/download/v6.9.4/onig-6.9.4.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -e 's|import requests|#\0|' \
		-e 's|urlretrieve(source_url, tarball_path)|shutil.copyfile(source_url, tarball_path)|' \
		-e "s|source_url=.*kkos/oniguruma.*|source_url=\"${DISTDIR}/onig-6.9.4.tar.gz\",|" \
		-e "s|source_url=.*stedolan/jq.*|source_url=\"${DISTDIR}/jq-1.6.tar.gz\",|" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
