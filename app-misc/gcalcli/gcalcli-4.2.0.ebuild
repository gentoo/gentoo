# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
# parsedatetime doesn't support pypy
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

MY_PV="4.2.0"

DESCRIPTION="Google Calendar Command Line Interface"
HOMEPAGE="https://github.com/insanum/gcalcli"
SRC_URI="https://github.com/insanum/gcalcli/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/google-api-python-client-1.5.3[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-gflags[${PYTHON_USEDEP}]
	dev-python/vobject[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/gcalcli-${MY_PV}"

src_install() {
	dodoc -r ChangeLog README.md docs
	distutils-r1_src_install
}
