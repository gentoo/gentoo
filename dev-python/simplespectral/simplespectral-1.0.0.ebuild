# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Heavily simplified scipy.signal.spectral module"
HOMEPAGE="https://github.com/xmikos/simplespectral"

LICENSE="MIT"
SLOT="0"

if [ "${PV}" = "9999" ]; then
	KEYWORDS=""
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xmikos/simplespectral.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xmikos/simplespectral/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

IUSE="faster +fastest"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
		faster? ( dev-python/scipy[${PYTHON_USEDEP}] )
		fastest? ( dev-python/pyFFTW[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
