# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="
	bs ca cs da de el es_AR es_CO es fr hu it ja nl no pl pt_BR pt_PT ru sv tr
	zh_CN zh_TW
"
inherit flag-o-matic plocale xdg-utils

DESCRIPTION="MS-Explorer-like minimalist file manager for X"
HOMEPAGE="http://roland65.free.fr/xfe/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug nls startup-notification"
# The only dir which defines a 'check' target is po/ which doesn't do anything
# useful for us. It also fails, see bug #847253.
RESTRICT="test"

RDEPEND="
	x11-libs/fox:1.6[png,truetype]
	media-libs/fontconfig
	x11-libs/libXrandr
	x11-libs/libX11
	x11-libs/libXft
	startup-notification? (
		x11-libs/libxcb:=
		x11-libs/startup-notification
		x11-libs/xcb-util
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	nls? (
		sys-devel/gettext
	)
"

DOCS=( AUTHORS BUGS ChangeLog README TODO )

src_prepare() {
	default

	cat >po/POTFILES.skip || die <<-EOF
	src/icons.cpp
	xfe.desktop.in.in
	xfi.desktop.in.in
	xfp.desktop.in.in
	xfv.desktop.in.in
	xfw.desktop.in.in
	EOF

	# malformed LINGUAS file
	# recent intltool expects newline for every linguas
	sed -i \
		-e '/^#/!s:\s\s*:\n:g' \
		po/LINGUAS || die

	# remove not selected locales
	rm_locale() { sed -i -e "/${1}/d" po/LINGUAS || die ;}
	plocale_for_each_disabled_locale rm_locale
}

src_configure() {
	# https://sourceforge.net/p/xfe/bugs/282/ (bug #864757)
	filter-lto

	econf \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable startup-notification sn) \
		--enable-minimalflags
}

src_install() {
	default

	# Install this unconditionally rather than automagically based on whether
	# polkit is installed
	rm -rf "${ED}"/usr/share/polkit-1/actions || die
	insinto /usr/share/polkit-1/actions
	newins - org.xfe.root.policy <<-EOF
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE policyconfig PUBLIC "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
		 "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
	<policyconfig>
	    <vendor>Xfe</vendor>
	    <vendor_url>http://roland65.free.fr/xfe</vendor_url>
	    <icon_name>xfe</icon_name>
	    <action id="org.xfe.root">
		<description>Run Xfe as root</description>
		<message>Authentication is required to run Xfe as root</message>
		<defaults>
			<allow_any>auth_admin</allow_any>
			<allow_inactive>auth_admin</allow_inactive>
			<allow_active>auth_admin</allow_active>
		</defaults>
		<annotate key="org.freedesktop.policykit.exec.path">${EPREFIX}/usr/bin/xfe</annotate>
		<annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
	</action>
	</policyconfig>
	EOF
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
