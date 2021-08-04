# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Simple config file reader and writer"
HOMEPAGE="http://www.voidspace.org.uk/python/configobj.html https://pypi.org/project/configobj/"
SRC_URI="https://github.com/DiffSK/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-fix-py2-tests.patch" )

distutils_enable_tests pytest
