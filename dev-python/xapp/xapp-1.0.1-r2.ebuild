# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Python bindings for x11-libs/xapps"
HOMEPAGE="https://github.com/linuxmint/python-xapp"
SRC_URI="https://github.com/linuxmint/python-xapp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="x11-libs/xapps[introspection]"
RDEPEND="${DEPEND}
	dev-python/psutil[${PYTHON_USEDEP}]"

S="${WORKDIR}/python-xapp-${PV}"
