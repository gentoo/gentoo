# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/u2ps/u2ps-0.8.4.ebuild,v 1.2 2015/01/31 13:00:34 hwoarang Exp $

EAPI=5

DESCRIPTION="A text to PostScript converter like a2ps, but supports UTF-8"
HOMEPAGE="http://sourceforge.net/projects/u2ps.berlios/"
SRC_URI="mirror://sourceforge/project/${PN}.berlios/${PN}-full-${PV}.tar.gz"

LICENSE="GPL-3 GPL-3-with-font-exception free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-lang/perl-5.6
	dev-perl/Text-CharWidth
	app-text/ghostscript-gpl
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-full-${PV}

src_configure() {
	./configure \
		--prefix=/usr \
		--datadir=/usr/share \
		--mandir=/usr/share/man \
		--with-perl=/usr/bin/perl \
		--with-gs=/usr/bin/gs \
		|| die 'configure failed'
}

src_compile() {
	emake
	emake man
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc README DESIGN
	doman man/u2ps.1
}
