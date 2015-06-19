# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyao/pyao-0.82-r2.ebuild,v 1.7 2012/02/21 08:49:16 patrick Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils eutils

DESCRIPTION="Python bindings for the libao library"
HOMEPAGE="http://www.andrewchatham.com/pyogg/"
SRC_URI="http://www.andrewchatham.com/pyogg/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc -sparc x86"
IUSE=""

DEPEND=">=media-libs/libao-1.0.0"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-new_api.patch
	distutils_src_prepare
}

src_configure() {
	"$(PYTHON -f)" ./config_unix.py || die
}

src_install() {
	distutils_src_install
	insinto /usr/share/doc/${PF}/examples
	doins test.py || die
}
