# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 edo

COMMIT="14118ad2e4d0da2e955fd9069b8772408307618b"
DESCRIPTION="An implementation of Vim in Python"
HOMEPAGE="https://pypi.org/project/pyvim/ https://github.com/prompt-toolkit/pyvim"
SRC_URI="https://github.com/prompt-toolkit/${PN}/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/prompt_toolkit[${PYTHON_USEDEP}]
	dev-python/pyflakes[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

eselect_vi_update() {
	if has_version app-eselect/eselect-vi; then
		edob eselect vi update --if-unset
	fi
}

pkg_postinst() {
	eselect_vi_update
}

pkg_postrm() {
	eselect_vi_update
}
