# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python{3_6,3_7} )
inherit distutils-r1

DESCRIPTION="Resolve GCC flag -march=native"
HOMEPAGE="https://github.com/hartwork/resolve-march-native"
SRC_URI="https://github.com/hartwork/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=sys-devel/gcc-4.2"
