# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
# python-gflags doesn't support python3
# parsedatetime doesn't support pypy
PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="Google Calendar Command Line Interface"
HOMEPAGE="https://github.com/insanum/gcalcli"
SRC_URI="https://github.com/insanum/gcalcli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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

src_prepare() {
	epatch "${FILESDIR}/gcalcli-oauth2client.patch"
}

src_install() {
	dodoc -r ChangeLog README.md docs
	python_foreach_impl python_doscript ${PN}
}
