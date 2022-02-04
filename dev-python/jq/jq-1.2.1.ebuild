# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python bindings for jq"
HOMEPAGE="https://github.com/mwilliamson/jq.py"
SRC_URI="
	https://github.com/mwilliamson/jq.py/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/stedolan/jq/releases/download/jq-1.6/jq-1.6.tar.gz
	https://github.com/kkos/oniguruma/releases/download/v6.9.4/onig-6.9.4.tar.gz"
S="${WORKDIR}/jq.py-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	sed -e 's|import requests|#\0|' \
		-e 's|urlretrieve(source_url, tarball_path)|shutil.copyfile(source_url, tarball_path)|' \
		-e "s|source_url=.*kkos/oniguruma.*|source_url=\"${DISTDIR}/onig-6.9.4.tar.gz\",|" \
		-e "s|source_url=.*stedolan/jq.*|source_url=\"${DISTDIR}/jq-1.6.tar.gz\",|" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_compile() {
	# Cython compilation isn't part of setup.py, so do it manually
	"${EPYTHON}" -m cython -3 jq.pyx -o jq.c || die
	distutils-r1_python_compile
}
