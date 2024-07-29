# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

DISTUTILS_USE_SETUPTOOLS="rdepend"
inherit distutils-r1

DESCRIPTION="A tool that figures out the differences between two similar XML files"
HOMEPAGE="https://github.com/Shoobx/xmldiff"
SRC_URI="https://github.com/Shoobx/xmldiff/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc x86 ~x86-linux"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

DOCS=( CHANGES.rst README.rst )
