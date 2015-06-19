# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-nodoka/gtk-engines-nodoka-0.7.5.ebuild,v 1.4 2012/06/04 14:54:59 pacho Exp $

EAPI=4
inherit eutils

MY_P="gtk-nodoka-engine-${PV}"

DESCRIPTION="GTK+ engine and themes developed by the Fedora Project"
HOMEPAGE="https://fedorahosted.org/nodoka/"
SRC_URI="https://fedorahosted.org/releases/n/o/nodoka/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="animation-rtl"

RDEPEND=">=x11-libs/gtk+-2.18.0:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-glib2.32.patch"
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-animation \
		$(use_enable animation-rtl animationtoleft)
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}
