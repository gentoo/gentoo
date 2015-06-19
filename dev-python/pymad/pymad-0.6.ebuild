# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pymad/pymad-0.6.ebuild,v 1.8 2011/01/29 16:40:08 armin76 Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Python wrapper for libmad MP3 decoding in python"
HOMEPAGE="http://www.spacepants.org/src/pymad/"
SRC_URI="http://www.spacepants.org/src/pymad/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libmad"
RDEPEND="${DEPEND}"

DOCS="AUTHORS THANKS"

src_configure() {
	echo "$(PYTHON -f)" config_unix.py --prefix "${EPREFIX}/usr"
	"$(PYTHON -f)" config_unix.py --prefix "${EPREFIX}/usr" || die "Configuration failed"
}
