# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_10 )
inherit distutils-r1

DESCRIPTION="Google Calendar Command Line Interface"
HOMEPAGE="https://github.com/insanum/gcalcli"
SRC_URI="https://github.com/insanum/gcalcli/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/google-api-python-client-1.5.3[${PYTHON_USEDEP}]
	dev-python/oauth2client[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-gflags[${PYTHON_USEDEP}]
	dev-python/vobject[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_install() {
	dodoc -r ChangeLog README.md docs
	distutils-r1_src_install
}
