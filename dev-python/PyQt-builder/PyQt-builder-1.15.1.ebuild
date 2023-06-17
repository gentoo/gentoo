# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="The PEP 517 compliant PyQt build system"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqt-builder/ https://pypi.org/project/PyQt-builder/"

if [[ ${PV} == *_pre* ]]; then
	MY_P=${PN}-${PV/_pre/.dev}
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
fi

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/sip-6.7.1[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc --no-autodoc

python_prepare_all() {
	# don't install prebuilt Windows DLLs
	sed -i -e "s:'dlls/\*/\*',::" setup.py || die
	rm -r "${PN/-/_}.egg-info" || die

	distutils-r1_python_prepare_all
}
