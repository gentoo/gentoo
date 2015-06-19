# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gaul-devel/gaul-devel-0.1849-r2.ebuild,v 1.3 2012/08/03 18:03:35 bicatali Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Genetic Algorithm Utility Library"
HOMEPAGE="http://GAUL.sourceforge.net/"
SRC_URI="mirror://sourceforge/gaul/${P}-0.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug slang static-libs"

DEPEND="
	sys-apps/sed
	slang? ( sys-libs/slang )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-0

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-slang2-error.patch \
		"${FILESDIR}"/${P}-as-needed.patch
	eautoreconf
}

src_configure() {
	local myconf
	use slang || myconf="--enable-slang=no"
	if use debug ; then
		myconf="${myconf} --enable-debug=yes --enable-memory-debug=yes"
	else
		myconf="${myconf} --enable-g=no"
	fi
	econf $(use_enable static-libs static) ${myconf}
}

src_install() {
	MAKEOPTS+=" -j1"
	default
}
