# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/upower/upower-0.99.0-r1.ebuild,v 1.7 2014/09/15 08:24:22 ago Exp $

EAPI=5
inherit eutils systemd

DESCRIPTION="D-Bus abstraction for enumerating power devices and querying history and statistics"
HOMEPAGE="http://upower.freedesktop.org/"
SRC_URI="http://${PN}.freedesktop.org/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/2" # based on SONAME of libupower-glib.so
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="+introspection ios kernel_FreeBSD kernel_linux"

RDEPEND=">=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.30
	sys-apps/dbus:=
	>=sys-auth/polkit-0.110
	introspection? ( dev-libs/gobject-introspection )
	kernel_linux? (
		virtual/libusb:1
		virtual/libgudev:=
		virtual/udev
		ios? (
			>=app-pda/libimobiledevice-1:=
			>=app-pda/libplist-1:=
			)
		)"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	dev-util/intltool
	virtual/pkgconfig"

QA_MULTILIB_PATHS="usr/lib/${PN}/.*"

DOCS="AUTHORS HACKING NEWS README"

src_prepare() {
	sed -i -e '/DISABLE_DEPRECATED/d' configure || die

	epatch \
		"${FILESDIR}"/${P}-create-dir-runtime.patch \
		"${FILESDIR}"/${P}-fix-shutdown-on-boot.patch \
		"${FILESDIR}"/${P}-fix-segfault.patch \
		"${FILESDIR}"/${P}-fix-typing-error.patch
}

src_configure() {
	local backend myconf

	if use kernel_linux; then
		backend=linux
	elif use kernel_FreeBSD; then
		backend=freebsd
	else
		backend=dummy
	fi

	econf \
		--libexecdir="${EPREFIX}"/usr/lib/${PN} \
		--localstatedir="${EPREFIX}"/var \
		$(use_enable introspection) \
		--disable-static \
		${myconf} \
		--enable-man-pages \
		--disable-tests \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--with-backend=${backend} \
		$(use_with ios idevice) \
		"$(systemd_with_utildir)" \
		"$(systemd_with_unitdir)"
}

src_install() {
	default

	# http://bugs.gentoo.org/487400
	insinto /usr/share/doc/${PF}/html/UPower
	doins doc/html/*
	dosym /usr/share/doc/${PF}/html/UPower /usr/share/gtk-doc/html/UPower

	keepdir /var/lib/upower #383091
	prune_libtool_files
}
