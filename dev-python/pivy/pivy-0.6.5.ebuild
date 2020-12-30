# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Coin3D bindings for Python"
HOMEPAGE="https://github.com/coin3d/pivy"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	PIVY_REPO_URI="https://github.com/coin3d/pivy.git"
else
	SRC_URI="https://github.com/coin3d/pivy/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
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
BDEPEND="dev-lang/swig"

PATCHES=( "${FILESDIR}/${PN}-0.6.4-find-SoQt.patch" )

DOCS=( AUTHORS HACKING NEWS README.md THANKS )
