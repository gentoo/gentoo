# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="MySQL abstraction layer for python"
HOMEPAGE="http://software.fionet.com/pSQL/"
SRC_URI="http://software.fionet.com/pSQL/release/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-python/mysql-python[${PYTHON_USEDEP}]
	dev-python/egenix-mx-base[${PYTHON_USEDEP}]"
DEPEND=""

src_install() {
	python_foreach_impl python_domodule pSQL.py

	dodoc *pSQL
}
