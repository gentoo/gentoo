# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gs-pypi/gs-pypi-0.2.ebuild,v 1.1 2015/04/24 22:00:02 jauhien Exp $

EAPI=5

PYTHON_COMPAT=(python{2_7,3_3,3_4})

inherit distutils-r1

DESCRIPTION="g-sorcery backend for pypi packages"
HOMEPAGE="https://github.com/jauhien/gs-pypi"
SRC_URI="https://github.com/jauhien/gs-pypi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=app-portage/g-sorcery-0.2[bson(-),$(python_gen_usedep 'python*')]
	dev-python/beautifulsoup:4[$(python_gen_usedep 'python*')]"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	doman docs/*.8
}
