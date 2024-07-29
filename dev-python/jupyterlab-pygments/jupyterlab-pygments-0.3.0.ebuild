# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Pygments theme making use of JupyterLab CSS variables"
HOMEPAGE="
	https://pypi.org/project/jupyterlab-pygments/
	https://github.com/jupyterlab/jupyterlab_pygments/
"
SRC_URI="$(pypi_wheel_url)"
S=${WORKDIR}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
"

src_unpack() {
	if [[ ${PKGBUMPING} == ${PVR} ]]; then
		unzip "${DISTDIR}/${A}" || die
	fi
}

python_compile() {
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${DISTDIR}/$(pypi_wheel_name)"
}
