# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

COMMIT="50d965879eb89fdef9be09d6e934329486ff585d"

DESCRIPTION="Small library containing various image processing algorithms"
HOMEPAGE="https://gitlab.gnome.org/World/OpenPaperwork/libpillowfight"
SRC_URI="https://gitlab.gnome.org/World/OpenPaperwork/${PN}/-/archive/${COMMIT}/${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pillow[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	ln -s "${S}"/tests "${T}"/tests || die
	sed -e "/'nose>=1.0'/d" -i setup.py || die
	cat > src/pillowfight/_version.h <<- EOF || die
		#define INTERNAL_PILLOWFIGHT_VERSION "$(ver_cut 1-3)"
	EOF
	distutils-r1_python_prepare_all
}

python_test() {
	cd "${T}" || die
	epytest "${S}"/tests -o addopts=
}
