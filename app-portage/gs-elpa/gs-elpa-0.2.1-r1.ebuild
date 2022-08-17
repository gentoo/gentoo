# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="g-sorcery backend for elisp packages"
HOMEPAGE="https://gitweb.gentoo.org/proj/gs-elpa.git
	https://github.com/jauhien/gs-elpa"
SRC_URI="https://gitweb.gentoo.org/proj/gs-elpa.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2" # v2 only
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="app-portage/g-sorcery[${PYTHON_USEDEP}]
	dev-python/sexpdata[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	doman docs/*.8
}
