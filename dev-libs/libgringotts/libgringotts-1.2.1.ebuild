# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgringotts/libgringotts-1.2.1.ebuild,v 1.12 2012/05/04 18:35:54 jdhore Exp $

DESCRIPTION="Needed by Gringotts"
HOMEPAGE="http://packages.debian.org/sid/libgringotts2"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-libs/libmcrypt-2.4.21
	>=app-crypt/mhash-0.8.13
	app-arch/bzip2
	sys-apps/coreutils
	sys-libs/zlib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" libgringottsdocdir="/usr/share/doc/${PF}" \
		install || die "emake install failed."
	rm -f "${D}"/usr/share/doc/${PF}/{COPYING,*.htm}
	dohtml -r docs/*.htm
	prepalldocs
}
