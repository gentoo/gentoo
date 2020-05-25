# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg-utils

DESCRIPTION="LightDM GTK+ Greeter"
HOMEPAGE="https://launchpad.net/lightdm-gtk-greeter"
SRC_URI="https://launchpad.net/lightdm-gtk-greeter/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz
	branding? ( https://dev.gentoo.org/~polynomial-c/dist/lightdm-gentoo-patch-2.tar.gz )"

LICENSE="GPL-3 LGPL-3
	branding? ( CC-BY-3.0 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ppc ppc64 ~x86"
IUSE="appindicator branding"

COMMON_DEPEND="appindicator? ( dev-libs/libindicator:3 )
	x11-libs/gtk+:3
	>=x11-misc/lightdm-1.2.2"

DEPEND="
	${COMMON_DEPEND}
	xfce-base/exo
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
"

RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-themes-standard
	>=x11-themes/adwaita-icon-theme-3.14.1"

GENTOO_BG="gentoo-bg_65.jpg"

src_prepare() {
	# Ok, this has to be fixed in the tarball but I am too lazy to do it.
	# I will fix this once I decide to update the tarball with a new gentoo
	# background
	# Bug #404467
	if use branding; then
		sed \
			-e "/xft-hintstyle/s:slight:hintslight:" \
			-e "/background/s:=.*:=/usr/share/lightdm/backgrounds/${GENTOO_BG}:" \
			-i "${WORKDIR}"/${PN}.conf || die
		# Add back the reboot/shutdown buttons
		echo 'indicators=~host;~spacer;~clock;~spacer;~session;~language;~a11y;~power;~' \
			>> "${WORKDIR}"/${PN}.conf || die
	fi
	default

	# Fix docdir
	sed "/^docdir/s@${PN}@${PF}@" -i data/Makefile.am || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-kill-on-sigterm
		--enable-at-spi-command="${EPREFIX}/usr/libexec/at-spi-bus-launcher --launch-immediately"
		$(use_enable appindicator libindicator)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use branding; then
		insinto /etc/lightdm/
		doins "${WORKDIR}"/${PN}.conf
		insinto /usr/share/lightdm/backgrounds/
		doins "${WORKDIR}"/${GENTOO_BG}
		newdoc "${WORKDIR}"/README.txt README-background.txt
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
