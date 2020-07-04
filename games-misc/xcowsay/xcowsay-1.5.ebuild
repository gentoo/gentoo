# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Displays a cute cow and message on your desktop"
HOMEPAGE="
	https://github.com/nickg/xcowsay
	https://www.doof.me.uk/xcowsay/
"
SRC_URI="https://github.com/nickg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dbus fortune nls"

RDEPEND="
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango
	dbus? (	dev-libs/dbus-glib )
	fortune? ( games-misc/fortune-mod )
"

DEPEND="${RDEPEND}"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default

	if ! use fortune; then
		sed -e 's/xcowfortune//g' -i src/Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-rpath
		$(use_enable dbus)
		$(use_enable nls)
	)

	econf ${myeconfargs[@]}
}
