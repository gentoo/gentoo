# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Obtain power spectrum from SoapySDR devices"
HOMEPAGE="https://github.com/xmikos/soapy_power"

LICENSE="MIT"
SLOT="0"

if [ "${PV}" = "9999" ]; then
	KEYWORDS=""
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xmikos/soapy_power.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/xmikos/soapy_power/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

IUSE="faster +fastest"

DEPEND=""
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/simplespectral[${PYTHON_USEDEP}]
	>=dev-python/simplesoapy-1.5.0[${PYTHON_USEDEP}]
		faster? ( sci-libs/scipy[${PYTHON_USEDEP}] )
		fastest? ( dev-python/pyFFTW[${PYTHON_USEDEP}] )"
