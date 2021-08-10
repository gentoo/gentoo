# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
MY_P="PyPAM-${PV}"
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1 flag-o-matic

DESCRIPTION="Python Bindings for PAM (Pluggable Authentication Modules)"
HOMEPAGE="http://www.pangalactic.org/PyPAM"
SRC_URI="http://www.pangalactic.org/PyPAM/${MY_P}.tar.gz
	https://distfiles.gentoo.org/distfiles/ad/PyPAM-0.5.0.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
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

src_compile() {
	append-cflags -fno-strict-aliasing
	distutils-r1_src_compile
}

python_test() {
	"${PYTHON}" tests/PamTest.py
}
