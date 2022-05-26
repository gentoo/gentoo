# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Resolve GCC flag -march=native"
HOMEPAGE="https://github.com/hartwork/resolve-march-native"
SRC_URI="https://github.com/hartwork/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

DEPEND=""
RDEPEND=">=sys-devel/gcc-4.2"

distutils_enable_tests pytest
