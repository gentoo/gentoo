# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/m2crypto/m2crypto-0.21.1-r3.ebuild,v 1.4 2015/05/26 22:34:33 floppym Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

MY_PN="M2Crypto"

DESCRIPTION="M2Crypto: A Python crypto and SSL toolkit"
HOMEPAGE="http://chandlerproject.org/bin/view/Projects/MeTooCrypto http://pypi.python.org/pypi/M2Crypto"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz
	http://dev.gentoo.org/~floppym/dist/m2crypto-0.21.1-backports.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples"

RDEPEND=">=dev-libs/openssl-0.9.8:0="
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.28
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_PN}-${PV}"

# Tests access network, and fail randomly. Bug #431458.
RESTRICT=test

PATCHES=(
	"${WORKDIR}"/patch/0.21.1-0001-Fixed-invalid-variable-name.patch
	"${WORKDIR}"/patch/0.21.1-0002-Fixing-memory-leaks-in-the-SWIG-wrapper.patch
	"${WORKDIR}"/patch/0.21.1-0003-Use-swig-generated-python-loader.patch
	"${FILESDIR}"/0.21.1-packaging.patch
)

python_test() {
	esetup.py test
}
