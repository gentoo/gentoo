# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="An alternative to sysvinit which supports the need(8) concept"
HOMEPAGE="http://john.fremlin.de/programs/linux/jinit/"
SRC_URI="http://john.fremlin.de/programs/linux/jinit/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "failed emake install"
	emake prefix="${D}"/usr/share/doc/${PF}/example-setup install-initscripts \
		|| die "failed installing example setup"
	mv "${D}"/usr/sbin "${D}"/ || die
	mv "${D}"/sbin/init "${D}"/sbin/jinit || die
	mv "${D}"/sbin/shutdown "${D}"/sbin/jinit-shutdown || die
	dodoc AUTHORS ChangeLog NEWS README TODO || die
}
