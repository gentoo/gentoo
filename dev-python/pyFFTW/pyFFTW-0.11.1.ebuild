# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )
inherit distutils-r1

DESCRIPTION="A pythonic python wrapper around FFTW"
HOMEPAGE="https://github.com/pyFFTW/pyFFTW"

LICENSE="BSD"
SLOT="0"
if [ "${PV}" = "9999" ]; then
	KEYWORDS=""
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pyFFTW/pyFFTW.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/pyFFTW/pyFFTW/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

IUSE=""

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/cython[${PYTHON_USEDEP}]
		>=sci-libs/fftw-3.3:3.0="
RDEPEND="${DEPEND}"
