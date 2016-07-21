# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils flag-o-matic

DESCRIPTION="USB support for Python"
HOMEPAGE="http://pyusb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

### The bus enumeration does not appear to work with libusb-compat
### A new version based on libusb-1.x is in the works, but not yet released
DEPEND="virtual/libusb:0"
RDEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3*"

src_install() {
	distutils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r samples
	fi
}
