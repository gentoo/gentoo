# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils systemd

DESCRIPTION="The upstream upower 0.9 git branch for use with sys-power/pm-utils"
HOMEPAGE="https://upower.freedesktop.org/"
SRC_URI="https://upower.freedesktop.org/releases/upower-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="+introspection ios kernel_FreeBSD kernel_linux"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.22
	sys-apps/dbus
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
		)
	!sys-power/upower"
RDEPEND="${COMMON_DEPEND}
	kernel_linux? ( >=sys-power/pm-utils-1.4.1-r2 )"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	dev-util/intltool
	>=sys-devel/gettext-0.17
	virtual/pkgconfig"

QA_MULTILIB_PATHS="usr/lib/upower/.*"

DOCS="AUTHORS HACKING NEWS README"

S=${WORKDIR}/upower-${PV}

src_prepare() {
	sed -i -e '/DISABLE_DEPRECATED/d' configure || die

	# https://bugs.freedesktop.org/show_bug.cgi?id=79565
	# https://bugzilla.xfce.org/show_bug.cgi?id=10931
	# Same effect as Debian -no_deprecation_define.patch, they patch .h, we patch .pc
	sed -i -e 's|Cflags: |&-DUPOWER_ENABLE_DEPRECATED |' upower-glib.pc.in || die

	# From upstream 0.9 git branch:
	epatch \
		"${FILESDIR}"/${P}-create-dir-runtime.patch \
		"${FILESDIR}"/${P}-fix-segfault.patch \
		"${FILESDIR}"/${P}-clamp_percentage_for_overfull_batt.patch

	# From Debian:
	epatch "${FILESDIR}"/${P}-always_use_pm-utils_backend.patch
}

src_configure() {
	local backend myconf

	if use kernel_linux; then
		backend=linux
		myconf="--enable-deprecated"
	elif use kernel_FreeBSD; then
		backend=freebsd
	else
		backend=dummy
	fi

	econf \
		--libexecdir="${EPREFIX}"/usr/lib/upower \
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

	# https://bugs.gentoo.org/487400
	insinto /usr/share/doc/${PF}/html/UPower
	doins doc/html/*
	dosym /usr/share/doc/${PF}/html/UPower /usr/share/gtk-doc/html/UPower

	keepdir /var/lib/upower #383091
	prune_libtool_files
}
