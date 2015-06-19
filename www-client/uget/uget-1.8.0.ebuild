# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/uget/uget-1.8.0.ebuild,v 1.7 2013/11/05 21:04:22 wired Exp $

EAPI="4"

inherit base

DESCRIPTION="Download manager using gtk+ and libcurl"
HOMEPAGE="http://www.ugetdm.com"
SRC_URI="mirror://sourceforge/urlget/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="aria2 +curl gstreamer gtk3 hide-temp-files libnotify nls"

REQUIRED_USE="|| ( aria2 curl )"

RDEPEND="
	dev-libs/libpcre
	>=dev-libs/glib-2:2
	!gtk3? (
		>=x11-libs/gtk+-2.18:2
	)
	gtk3? (
		x11-libs/gtk+:3
	)
	curl? ( >=net-misc/curl-7.10 )
	gstreamer? ( media-libs/gstreamer:0.10 )
	libnotify? ( x11-libs/libnotify )
	"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	# add missing file, fix tests, bug #376203
	echo "uglib/UgPlugin-aria2.c" >> po/POTFILES.in ||
		die "echo in po/POTFILES.in failed"
}

src_configure() {
	econf $(use_enable nls) \
		  $(use_with gtk3) \
		  $(use_enable curl plugin-curl) \
		  $(use_enable aria2 plugin-aria2) \
		  $(use_enable gstreamer) \
		  $(use_enable hide-temp-files hidden) \
		  $(use_enable libnotify notify)
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install

	# the build system forgets this :p
	dobin uget-cmd/uget-cmd

	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	if use aria2; then
		echo
		elog "You've enabled the aria2 USE flag, so the aria2 plug-in has been"
		elog "built. This allows you to control a local or remote instance of aria2"
		elog "through xmlrpc. To use aria2 locally you have to emerge"
		elog "net-misc/aria2 with the xmlrpc USE enabled manually."
		echo
	fi
}
