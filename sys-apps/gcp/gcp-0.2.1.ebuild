# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="File copying utility with progress and I/O indicator"
HOMEPAGE="https://code.lm7.fr/mcy/gcp"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/progressbar[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-0.2.1-gentoo-fhs.patch )
