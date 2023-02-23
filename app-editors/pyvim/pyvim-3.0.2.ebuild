# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="An implementation of Vim in Python"
HOMEPAGE="https://pypi.org/project/pyvim https://github.com/prompt-toolkit/pyvim"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	app-eselect/eselect-vi
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/prompt-toolkit[${PYTHON_USEDEP}]
	dev-python/pyflakes[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
"

eselect_vi_update() {
	ebegin "Calling eselect vi update"
	eselect vi update --if-unset
	eend $?
}

pkg_postinst() {
	eselect_vi_update
}

pkg_postrm() {
	eselect_vi_update
}
