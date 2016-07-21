# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Holland MySQL Library"
HOMEPAGE="http://www.hollandbackup.org/"

MY_P="${P%%-*}-${P##*-}"

SRC_URI="http://hollandbackup.org/releases/stable/${PV%.*}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	~app-backup/holland-lib-common-${PV}[${PYTHON_USEDEP}]
	<dev-python/mysql-python-1.2.5[${PYTHON_USEDEP}]
"
PDEPEND="~app-backup/holland-${PV}[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}/plugins/${PN//-/.}"

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}
