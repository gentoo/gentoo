# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

DISTUTILS_USE_SETUPTOOLS="rdepend"
inherit distutils-r1

distutils_enable_tests unittest

DESCRIPTION="A tool that figures out the differences between two similar XML files"
HOMEPAGE="https://github.com/Shoobx/xmldiff"
SRC_URI="https://github.com/Shoobx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-linux"
IUSE=""

RDEPEND="dev-python/setuptools
	dev-python/lxml
	dev-python/six"

DOCS=( CHANGES.rst README.rst )
