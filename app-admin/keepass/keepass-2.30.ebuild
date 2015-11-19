# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fdo-mime gnome2-utils mono-env multilib

MY_PN="KeePass"
DESCRIPTION="A free, open source, light-weight and easy-to-use password manager"
HOMEPAGE="http://keepass.info/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}-Source.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="aot"

COMMON_DEPEND=">=dev-lang/mono-2.10.5"
RDEPEND="${COMMON_DEPEND}
	dev-dotnet/libgdiplus[cairo]"
DEPEND="${COMMON_DEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	# Remove Windows-specific things
	pushd Build > /dev/null || die
	. PrepMonoDev.sh || die
	popd > /dev/null || die

	# KeePass looks for some XSL files in the same folder as the executable,
	# we prefer to have it in /usr/share/KeePass
	epatch "${FILESDIR}/${PN}-2.20-xsl-path-detection.patch"
	# bug # 558094
	has_version ">=dev-lang/mono-4" && epatch \
		"${FILESDIR}/${P}-mono-4-support.patch"
}

src_compile() {
	# Build with Release target
	xbuild /target:KeePass /property:Configuration=Release || die

	# Run Ahead Of Time compiler on the binary
	if use aot; then
		cp Ext/KeePass.exe.config Build/KeePass/Release/
		mono --aot -O=all Build/KeePass/Release/KeePass.exe || die
	fi
}

src_install() {
	# Wrapper script to launch mono
	make_wrapper ${PN} "mono /usr/$(get_libdir)/${PN}/KeePass.exe"

	# Some XSL files
	insinto /usr/share/${PN}/XSL
	doins Ext/XSL/*

	insinto /usr/$(get_libdir)/${PN}/
	exeinto /usr/$(get_libdir)/${PN}/
	doins Ext/KeePass.exe.config
	# Default configuration, simply says to use user-specific configuration
	doins Ext/KeePass.config.xml

	# The actual executable
	doexe Build/KeePass/Release/KeePass.exe

	# Copy the AOT compilation result
	if use aot; then
		doexe Build/KeePass/Release/KeePass.exe.so
	fi

	# Prepare the icons
	newicon -s 256 Ext/Icons/Finals/plockb.png "${PN}.png"
	newicon -s 256 -t gnome -c mimetypes Ext/Icons/Finals/plockb.png "application-x-${PN}2.png"

	# Create a desktop entry and associate it with the KeePass mime type
	make_desktop_entry ${PN} ${MY_PN} ${PN} "System;Security" "MimeType=application/x-keepass2;"

	# MIME descriptor for .kdbx files
	insinto /usr/share/mime/packages/
	doins "${FILESDIR}/${PN}.xml"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update

	if ! has_version x11-misc/xdotool ; then
		elog "Optional dependencies:"
		elog "	x11-misc/xdotool (enables autotype)"
	fi

	elog "Some systems may experience issues with copy and paste operations."
	elog "If you encounter this, please install x11-misc/xsel."
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
