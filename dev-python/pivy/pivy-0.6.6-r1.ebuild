# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Coin3D bindings for Python"
HOMEPAGE="https://github.com/coin3d/pivy"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	PIVY_REPO_URI="https://github.com/coin3d/pivy.git"
else
	SRC_URI="https://github.com/coin3d/pivy/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="+quarter soqt"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( quarter soqt )
"

RDEPEND="
	>=media-libs/coin-4.0.0
	quarter? ( media-libs/quarter )
	soqt? ( >=media-libs/SoQt-1.6.0 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swig
	dev-util/cmake
"

PATCHES=(
	"${FILESDIR}"/${P}-0001-fix-CMakeLists.txt-for-distutils_cmake.patch
	"${FILESDIR}"/${P}-0002-Gentoo-specific-clear-swig-deprecation-warning.patch
)

DOCS=( AUTHORS HACKING NEWS README.md THANKS )
