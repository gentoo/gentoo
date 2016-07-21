# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools eutils

DESCRIPTION="A small command-line based Direct Connect client"
HOMEPAGE="http://corsair626.no-ip.org/microdc/"
SRC_URI="http://corsair626.no-ip.org/microdc/${P}.tar.gz
	mirror://debian/pool/main/m/${PN}/${PN}_${PV}-1.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="app-arch/bzip2
	>=dev-libs/libxml2-2.6.16
	sys-libs/ncurses
	>=sys-libs/readline-4"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	local dpatch="${WORKDIR}/debian/patches"

	epatch \
		"${dpatch}"/disable-libxml2-version-check \
		"${dpatch}"/rename-manpage \
		"${dpatch}"/disable-make-tthsum \
		"${dpatch}"/debian-link-system-bz2

	eautoreconf
}

src_compile() {
	econf \
		$(use_enable nls)

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README doc/*
}
