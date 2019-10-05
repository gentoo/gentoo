# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

MY_PN="RBTools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Command line tools for use with Review Board"
HOMEPAGE="https://www.reviewboard.org/"
SRC_URI="https://downloads.reviewboard.org/releases/${MY_PN}/$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="
	>=dev-python/six-1.8.0[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

DOCS=( AUTHORS NEWS README.md )

S=${WORKDIR}/${MY_P}
