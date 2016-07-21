# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xfconf # autotools

DESCRIPTION="A lightweight music player (with support for the Xfce desktop environment)"
HOMEPAGE="http://pragha.wikispaces.com/ https://github.com/matiasdelellis/pragha"
SRC_URI="https://github.com/matiasdelellis/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +glyr grilo +keybinder lastfm libnotify mtp +peas +playlist rygel soup +udev"

COMMON_DEPEND=">=dev-db/sqlite-3.4:3=
	>=dev-libs/glib-2.32:=
	>=dev-libs/libcdio-0.90:=
	>=dev-libs/libcdio-paranoia-0.90:=
	media-libs/gst-plugins-base:1.0=
	>=media-libs/libcddb-1.3.0:=
	>=media-libs/taglib-1.7.0:=
	>=x11-libs/gtk+-3.4:3=
	>=xfce-base/libxfce4ui-4.11:=[gtk3(+)]
	glyr? ( >=media-libs/glyr-1.0.1:= )
	grilo? ( >=media-libs/grilo-0.2.10:= )
	keybinder? ( >=dev-libs/keybinder-0.2.0:3= )
	lastfm? ( >=media-libs/libclastfm-0.5:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	mtp? ( >=media-libs/libmtp-1.1.0:= )
	peas? ( >=dev-libs/libpeas-1.0.0:=[gtk] )
	playlist? ( >=dev-libs/totem-pl-parser-2.26:= )
	rygel? ( >=net-misc/rygel-0.20:= )
	soup? ( >=net-libs/libsoup-2.38:= )
	udev? ( virtual/libgudev:= )"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:1.0"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	>=dev-util/xfce4-dev-tools-4.10
	sys-devel/gettext
	virtual/pkgconfig"
REQUIRED_USE="glyr? ( peas )
	grilo? ( peas )
	libnotify? ( peas )
	mtp? ( udev )
	rygel? ( peas )
	soup? ( peas )
	udev? ( peas )"

pkg_setup() {
	XFCONF=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable debug)
		$(use_enable peas libpeas-1.0)
		$(use_enable glyr libglyr)
		$(use_enable lastfm libclastfm)
		$(use_enable playlist totem-plparser)
		--with-gstreamer=1.0
		)

	if use peas; then
		XFCONF+=(
			$(use_enable libnotify)
			$(use_enable keybinder)
			$(use_enable udev gudev-1.0)
			$(use_enable mtp libmtp)
			$(use_enable soup libsoup-2.4)
			$(use_enable rygel rygel-server-2.2)
			$(use_enable grilo grilo-0.2)
			)
	else
		XFCONF+=(
			--disable-libnotify
			--disable-keybinder
			--disable-gudev-1.0
			--disable-libmtp
			--disable-libsoup-2.4
			--disable-rygel-server-2.2
			--disable-grilo-0.2
			)
	fi
}

src_prepare() {
	sed -i -e '/CFLAGS/s:-g -ggdb -O0::' configure || die

	# Prevent glib-gettextize from running wrt #423115
#	export AT_M4DIR=${EPREFIX}/usr/share/xfce4/dev-tools/m4macros
#	intltoolize --automake --copy --force
#	_elibtoolize --copy --force --install
#	eaclocal; eautoconf; eautoheader; eautomake

	xfconf_src_prepare
}
