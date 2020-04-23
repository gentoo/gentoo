# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

MY_PN="MiniMock"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The simplest possible mock library"
HOMEPAGE="https://pypi.org/project/MiniMock/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc x86"

S="${WORKDIR}/${MY_P}"

DOCS=( docs/changelog.rst docs/index.rst )

python_test() {
	"${PYTHON}" -m doctest minimock.py || die "Tests fail with ${EPYTHON}"
}
