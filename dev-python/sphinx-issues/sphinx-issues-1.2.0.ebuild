# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Sphinx extension for linking to your project's issue tracker"
HOMEPAGE="https://github.com/sloria/sphinx-issues"
SRC_URI="https://github.com/sloria/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
