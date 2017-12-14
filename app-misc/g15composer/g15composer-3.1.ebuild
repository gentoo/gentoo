# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2
inherit eutils

DESCRIPTION="A library to render text and shapes into a buffer usable by the Logitech G15"
HOMEPAGE="https://sourceforge.net/projects/g15tools/"
SRC_URI="mirror://sourceforge/g15tools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="truetype examples"

DEPEND="app-misc/g15daemon
	>=dev-libs/libg15render-1.2[truetype?]
	truetype? ( media-libs/freetype )"

src_configure() {
	econf \
		$(use_enable truetype ttf)
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	newinitd "${FILESDIR}/${P}.initd" ${PN}
	newconfd "${FILESDIR}/${P}.confd" ${PN}

	dodoc AUTHORS README ChangeLog

	if use examples ; then
		exeinto "/usr/share/${PN}"
		doexe examples/*
	fi
}

pkg_postinst() {
	elog "Set the user to run g15composer in /etc/conf.d/g15composer before starting the service."
}
