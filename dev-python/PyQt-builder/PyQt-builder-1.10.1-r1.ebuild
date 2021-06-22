# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="The PEP 517 compliant PyQt build system"
HOMEPAGE="https://www.riverbankcomputing.com/software/pyqt-builder/ https://pypi.org/project/PyQt-builder/"

MY_P=${PN}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
fi
S=${WORKDIR}/${MY_P}

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/sip-5.5[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc --no-autodoc

python_prepare_all() {
	# don't install prebuilt Windows DLLs
	sed -i -e "s:'dlls/\*/\*',::" setup.py || die
	rm -r "${PN/-/_}.egg-info" || die

	distutils-r1_python_prepare_all
}
