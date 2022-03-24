# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
MY_P="PyPAM-${PV}"
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python Bindings for PAM (Pluggable Authentication Modules)"
HOMEPAGE="http://www.pangalactic.org/PyPAM"
SRC_URI="http://www.pangalactic.org/PyPAM/${MY_P}.tar.gz
	https://distfiles.gentoo.org/distfiles/ad/PyPAM-0.5.0.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE=""

DEPEND=">=sys-libs/pam-0.64"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS examples/pamtest.py )

PATCHES=(
	# Pull patches from fedora.
	"${FILESDIR}/PyPAM-${PV}-dealloc.patch"
	"${FILESDIR}/PyPAM-${PV}-nofree.patch"
	"${FILESDIR}/PyPAM-${PV}-memory-errors.patch"
	"${FILESDIR}/PyPAM-${PV}-return-value.patch"
	"${FILESDIR}/PyPAM-python3-support.patch"
	# Fix a missing include.
	"${FILESDIR}/${P}-stricter.patch"
)

python_test() {
	"${EPYTHON}" tests/PamTest.py || die
}
