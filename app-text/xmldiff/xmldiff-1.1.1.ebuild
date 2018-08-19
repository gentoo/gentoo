# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{5,6}} )

inherit distutils-r1

DESCRIPTION="A tool that figures out the differences between two similar XML files"
HOMEPAGE="https://github.com/Shoobx/xmldiff"
SRC_URI="https://github.com/Shoobx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-linux"
IUSE=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/future
	dev-python/lxml
	dev-python/six"
DOCS=( AUTHORS.rst CHANGES.rst README.rst TODO.rst )
