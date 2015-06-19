# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdcd/cdcd-0.6.6-r2.ebuild,v 1.8 2014/12/16 10:42:44 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="a simple yet powerful command line cd player"
HOMEPAGE="http://libcdaudio.sourceforge.net"
SRC_URI="mirror://sourceforge/libcdaudio/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ppc64 sparc x86 ~x86-fbsd"

RDEPEND="
	>=sys-libs/readline-4.2
	>=media-libs/libcdaudio-0.99.4
"
DEPEND="${RDEPEND}"

src_prepare() {
	cp "${FILESDIR}"/${P}-acinclude.m4 "${S}"/acinclude.m4 || die
	epatch "${FILESDIR}"/${P}-configure.patch
	eautoreconf
}

DOCS=( AUTHORS ChangeLog NEWS README )
