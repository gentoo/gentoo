# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/enum/enum-1.1.ebuild,v 1.1 2012/02/02 20:23:00 sping Exp $

EAPI="2"

DESCRIPTION="Replacement for GNU seq and BSD jot"
HOMEPAGE="https://fedorahosted.org/enum/"
SRC_URI="https://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	# Remove bundled getopt
	rm -R thirdparty || die
}

src_configure() {
	econf --disable-doc-rebuild --disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die 'emake install'
	dodoc ChangeLog || die 'dodoc failed'
}
