# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2-utils

DESCRIPTION="A simple locker using lightdm"
HOMEPAGE="https://github.com/the-cavalry/light-locker"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dpms elogind +screensaver systemd +upower"

BDEPEND="dev-lang/perl
	dev-perl/XML-Parser
	dev-util/intltool
	sys-devel/gettext"
DEPEND="dev-libs/dbus-glib
	dev-libs/glib
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
	x11-libs/libXxf86vm
	dpms? ( x11-libs/libXext )
	elogind? ( sys-auth/elogind )
	screensaver? ( x11-libs/libXScrnSaver )
	systemd? ( sys-apps/systemd )
	upower? ( sys-power/upower )"
RDEPEND="${DEPEND}
	x11-misc/lightdm"

REQUIRED_USE="?? ( elogind systemd )"

DOCS=( AUTHORS HACKING NEWS README )

PATCHES=(
	"${FILESDIR}/${P}-elogind.patch"
)

src_prepare() {
	default
	# Fixed upstream right after the release, remove this next time you bump
	ln -sf README.md README || die
	# remove xdt-autogen specific macro (just like upstream do) as we need to autoreconf
	sed -e "/XDT_I18N/d" configure.ac.in > configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with dpms dpms-ext)
		$(use_with screensaver x)
		$(use_with screensaver mit-ext)
		$(use_with systemd)
		$(use_with elogind)
		$(use_with upower)
	)
	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
