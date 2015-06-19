# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/pragha/pragha-1.3.0.ebuild,v 1.5 2015/05/11 17:11:31 mgorny Exp $

EAPI=5
inherit autotools xfconf

DESCRIPTION="A lightweight music player (with support for the Xfce desktop environment)"
HOMEPAGE="http://pragha.wikispaces.com/ http://github.com/matiasdelellis/pragha"
SRC_URI="http://github.com/matiasdelellis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +glyr +keybinder lastfm libnotify mtp +peas +playlist +udev"

COMMON_DEPEND=">=dev-db/sqlite-3.4:3
	>=dev-libs/glib-2.32
	>=dev-libs/libcdio-0.90
	>=dev-libs/libcdio-paranoia-0.90
	media-libs/gst-plugins-base:1.0
	>=media-libs/libcddb-1.3.0
	>=media-libs/taglib-1.7.0
	>=x11-libs/gtk+-3.4:3
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.11[gtk3(+)]
	glyr? ( >=media-libs/glyr-1.0.1 )
	keybinder? ( >=dev-libs/keybinder-0.2.0:3 )
	lastfm? ( >=media-libs/libclastfm-0.5 )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	mtp? ( >=media-libs/libmtp-1.1.0 )
	peas? ( >=dev-libs/libpeas-1.0.0[gtk] )
	playlist? ( >=dev-libs/totem-pl-parser-2.26 )
	udev? ( virtual/libgudev:= )"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:1.0"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	>=dev-util/xfce4-dev-tools-4.10
	sys-devel/gettext
	virtual/pkgconfig"
REQUIRED_USE="glyr? ( peas )
	libnotify? ( peas )
	mtp? ( udev )
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
			)
	else
		XFCONF+=(
			--disable-libnotify
			--disable-keybinder
			--disable-gudev-1.0
			--disable-libmtp
			)
	fi
}

src_prepare() {
	sed -i -e '/CFLAGS/s:-g -ggdb -O0::' configure.ac || die

	# Prevent glib-gettextize from running wrt #423115
	export AT_M4DIR=${EPREFIX}/usr/share/xfce4/dev-tools/m4macros
	intltoolize --automake --copy --force
	_elibtoolize --copy --force --install
	eaclocal; eautoconf; eautoheader; eautomake

	xfconf_src_prepare
}
