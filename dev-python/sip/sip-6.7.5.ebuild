# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python bindings generator for C/C++ libraries"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/ https://pypi.org/project/sip/"

MY_P=${PN}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"
fi
S=${WORKDIR}/${MY_P}

LICENSE="|| ( GPL-2 GPL-3 SIP )"
SLOT="5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	!<dev-python/sip-4.19.25-r1[${PYTHON_USEDEP}]
	!=dev-python/sip-5.5.0-r0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"

distutils_enable_sphinx doc --no-autodoc
