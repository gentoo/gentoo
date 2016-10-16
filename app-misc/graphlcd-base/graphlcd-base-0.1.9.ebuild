# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic multilib

VERSION="501" #every bump, new version

DESCRIPTION="Graphical LCD Driver"
HOMEPAGE="https://projects.vdr-developer.org/projects/graphlcd-base"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="g15"

DEPEND="media-libs/freetype"
RDEPEND="g15? ( app-misc/g15daemon )
		media-libs/freetype"

src_prepare() {
	sed -i Make.config -e "s:usr\/local:usr:" -e "s:FLAGS *=:FLAGS ?=:"
	eapply "${FILESDIR}/${PN}-0.1.5-nostrip.patch"

	sed -i glcdskin/Makefile -e "s:-shared:\$(LDFLAGS) -shared:"

	#gcc-6 fix
	sed -i glcddrivers/futabaMDM166A.c -e "s:0xff7f0004:(int) 0xff7f0004:"

	default
}

src_install() {
	emake DESTDIR="${D}"/usr LIBDIR="${D}"/usr/$(get_libdir) install

	insinto /etc
	doins graphlcd.conf

	local DOCS=( HISTORY README docs/* )

	einstalldocs
}
