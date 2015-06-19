# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gtkguitune/gtkguitune-0.8.ebuild,v 1.3 2012/05/05 08:26:50 mgorny Exp $

EAPI=2
inherit eutils gnome2-utils

DESCRIPTION="A guitar tuning program that uses Schmitt-triggering for quick feedback"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${PN}-gtk2-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-cpp/glibmm:2
	dev-cpp/gtkmm:2.4
	dev-libs/libsigc++:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README
	make_desktop_entry ${PN} Guitune guitune_logo
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
