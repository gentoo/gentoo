# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnustep-2

S="${WORKDIR}/Etoile-${PV}/Frameworks/IconKit"

DESCRIPTION="framework used to create icons using different elements"
HOMEPAGE="http://www.etoile-project.org"
SRC_URI="http://download.gna.org/etoile/etoile-${PV}.tar.bz2"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE=""

DEPEND="media-libs/libpng"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	cd "${WORKDIR}/Etoile-${PV}"
	sed -i -e "s/-Werror//" etoile.make || die "sed failed"
}
