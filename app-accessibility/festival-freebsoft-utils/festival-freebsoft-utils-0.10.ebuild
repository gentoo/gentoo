# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/festival-freebsoft-utils/festival-freebsoft-utils-0.10.ebuild,v 1.2 2012/10/20 09:38:07 ago Exp $

EAPI="4"

DESCRIPTION="a collection of Festival functions for speech-dispatcher"
HOMEPAGE="http://www.freebsoft.org/festival-freebsoft-utils"
SRC_URI="http://www.freebsoft.org/pub/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-accessibility/festival-1.4.3
	media-sound/sox
	virtual/libiconv"
# We depend on virtual/libiconv for the iconv command-line tool.  This
# command should be available in both packages providing the virtual.

src_compile(){
	einfo "Nothing to compile."
}

src_install() {
	dodoc ANNOUNCE NEWS README
	doinfo doc/*.info
	insinto /usr/share/festival
	doins "${S}"/*.scm
}
