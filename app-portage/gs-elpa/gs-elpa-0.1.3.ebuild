# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=(python2_7)

inherit distutils-r1

DESCRIPTION="g-sorcery backend for elisp packages"
HOMEPAGE="https://github.com/jauhien/gs-elpa"
SRC_URI="https://github.com/jauhien/gs-elpa/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-portage/g-sorcery[$(python_gen_usedep 'python*')]
	dev-python/sexpdata[$(python_gen_usedep 'python*')]"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	doman docs/*.8
}
