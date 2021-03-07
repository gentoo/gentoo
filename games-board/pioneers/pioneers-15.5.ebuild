# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Clone of the popular board game The Settlers of Catan"
HOMEPAGE="http://pio.sourceforge.net/"
SRC_URI="mirror://sourceforge/pio/${P}.tar.gz"

LICENSE="GPL-2 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated help nls"

# dev-util/gob only for autoreconf
RDEPEND="
	>=dev-libs/glib-2.28:2
	!dedicated?	(
		>=x11-libs/gtk+-3.22:3
		>=x11-libs/libnotify-0.7.4
		help? ( app-text/yelp-tools )
	)
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gob:2
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog README TODO NEWS )

PATCHES=( "${FILESDIR}/${P}-fno-common.patch" )

src_configure() {
	gnome2_src_configure \
		$(use_enable nls) \
		$(use_enable help) \
		--includedir=/usr/include \
		$(use_with !dedicated gtk)
}

src_install() {
	gnome2_src_install scrollkeeper_localstate_dir="${ED%/}"/var/lib/scrollkeeper/
}
