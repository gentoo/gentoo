# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=(python{2_7,3_4,3_5})

inherit distutils-r1

DESCRIPTION="g-sorcery backend for pypi packages"
HOMEPAGE="https://github.com/jauhien/gs-pypi"
SRC_URI="https://github.com/jauhien/gs-pypi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=app-portage/g-sorcery-0.2.1[bson(-),git(-),$(python_gen_usedep 'python*')]
	dev-python/beautifulsoup:4[$(python_gen_usedep 'python*')]"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	doman docs/*.8
}
