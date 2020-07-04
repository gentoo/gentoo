# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="A Sphinx extension for linking to your project's issue tracker "
HOMEPAGE="https://github.com/sloria/sphinx-issues"
SRC_URI="https://github.com/sloria/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
