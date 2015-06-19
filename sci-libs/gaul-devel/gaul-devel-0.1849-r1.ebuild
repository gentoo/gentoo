# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gaul-devel/gaul-devel-0.1849-r1.ebuild,v 1.6 2011/06/26 14:47:52 jlec Exp $

inherit eutils

DESCRIPTION="Genetic Algorithm Utility Library"
HOMEPAGE="http://GAUL.sourceforge.net/"
SRC_URI="mirror://sourceforge/gaul/${P}-0.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug slang"

DEPEND="
	sys-apps/sed
	slang? ( sys-libs/slang )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-0

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-slang2-error.patch
}

src_compile() {
	local myconf
	use slang || myconf="--enable-slang=no"
	if use debug ; then
		myconf="${myconf} --enable-debug=yes --enable-memory-debug=yes"
	else
		myconf="${myconf} --enable-g=no"
	fi
	econf ${myconf}
	emake || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "Install failed"
	dodoc README || die
}
