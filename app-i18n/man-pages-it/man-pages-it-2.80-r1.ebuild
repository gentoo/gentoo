# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/man-pages-it/man-pages-it-2.80-r1.ebuild,v 1.8 2014/01/30 20:28:08 vapier Exp $

EAPI=5

DESCRIPTION="A somewhat comprehensive collection of Italian Linux man pages"
HOMEPAGE="http://it.tldp.org/man/"
SRC_URI="ftp://ftp.pluto.it/pub/pluto/ildp/man/${P}.tar.gz"

LICENSE="man-pages GPL-2+ BSD MIT FDL-1.1+ public-domain man-pages-posix"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/man"

src_prepare() {
	# bug 480970
	rm man5/{dpkg.cfg,deb,deb-control}.5 || die
}

src_compile() { :; } # emake does bad things here

src_install() {
	doman -i18n=it man*/*

	dodoc description readme CHANGELOG HOWTOHELP POSIX-COPYRIGHT
}
