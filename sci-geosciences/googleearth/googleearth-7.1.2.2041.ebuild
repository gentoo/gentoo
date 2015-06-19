# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/googleearth/googleearth-7.1.2.2041.ebuild,v 1.2 2015/03/10 00:56:23 mschiff Exp $

EAPI=5

inherit pax-utils eutils unpacker fdo-mime gnome2-utils

DESCRIPTION="A 3D interface to the planet"
HOMEPAGE="http://earth.google.com/"
# no upstream versioning, version determined from help/about
# incorrect digest means upstream bumped and thus needs version bump
SRC_URI="x86? ( http://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb
			-> GoogleEarthLinux-${PV}_i386.deb )
	amd64? ( http://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
			-> GoogleEarthLinux-${PV}_amd64.deb )"
LICENSE="googleearth GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror splitdebug"
IUSE="+bundled-libs"

QA_PREBUILT="*"

# TODO: find a way to unbundle libQt
# ./googleearth-bin: symbol lookup error: ./libbase.so: undefined symbol: _Z34QBasicAtomicInt_fetchAndAddOrderedPVii

RDEPEND="
	dev-libs/glib:2
	dev-libs/nspr
	media-libs/fontconfig
	media-libs/freetype
	net-misc/curl
	sys-devel/gcc[cxx]
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	virtual/ttf-fonts
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXau
	x11-libs/libXdmcp
	!bundled-libs? (
		dev-db/sqlite:3
		dev-libs/expat
		dev-libs/nss
		sci-libs/gdal
		sci-libs/proj
	)"
DEPEND="dev-util/patchelf"

S=${WORKDIR}/opt/google/earth/free

pkg_nofetch() {
	einfo "Wrong checksum or file size means that Google silently replaced the distfile with a newer version."
	einfo "Note that Gentoo cannot mirror the distfiles due to license reasons, so we have to follow the bump."
	einfo "Please file a version bump bug on http://bugs.gentoo.org (search existing bugs for googleearth first!)."
	einfo "By redigesting the file yourself, you will install a different version than the ebuild says, untested!"
}

src_unpack() {
	# default src_unpack fails with deb2targz installed, also this unpacks the data.tar.lzma as well
	unpack_deb GoogleEarthLinux-${PV}_$(usex amd64 "amd64" "i386").deb

	if ! use bundled-libs ; then
		einfo "removing bundled libs"
		cd opt/google/earth/free || die
		# sci-libs/gdal
		rm -v libgdal.so.1 || die
		# dev-db/sqlite
		rm -v libsqlite3.so || die
		# dev-libs/nss
		rm -v libplc4.so libplds4.so libnspr4.so libnssckbi.so libfreebl3.so \
			libnssdbm3.so libnss3.so libnssutil3.so libsmime3.so libnsssysinit.so \
			libsoftokn3.so libssl3.so || die
		# dev-libs/expat
		rm -v libexpat.so.1 || die
		# sci-libs/proj
		rm -v libproj.so.0 || die
		# dev-qt/qtcore:4 dev-qt/qtgui:4 dev-qt/qtwebkit:4
#		rm -v libQt{Core,Gui,Network,WebKit}.so.4 || die
#		rm -rv plugins/imageformats || die
	fi
}

src_prepare() {
	# we have no ld-lsb.so.3 symlink
	# thanks to Nathan Phillip Brink <ohnobinki@ohnopublishing.net> for suggesting patchelf
	einfo "running patchelf"
	patchelf --set-interpreter /lib/ld-linux$(usex amd64 "-x86-64" "").so.2 ${PN}-bin || die "patchelf failed"

	# Set RPATH for preserve-libs handling (bug #265372).
	local x
	for x in * ; do
		# Use \x7fELF header to separate ELF executables and libraries
		[[ -f ${x} && $(od -t x1 -N 4 "${x}") == *"7f 45 4c 46"* ]] || continue
		patchelf --set-rpath '$ORIGIN' "${x}" ||
			die "patchelf failed on ${x}"
	done
	for x in plugins/*.so ; do
		[[ -f ${x} ]] || continue
		patchelf --set-rpath '$ORIGIN/..' "${x}" ||
			die "patchelf failed on ${x}"
	done
	for x in plugins/imageformats/*.so ; do
		[[ -f ${x} ]] || continue
		patchelf --set-rpath '$ORIGIN/../..' "${x}" ||
			die "patchelf failed on ${x}"
	done

	epatch "${FILESDIR}"/${PN}-${PV%%.*}-desktopfile.patch
}

src_install() {
	make_wrapper ${PN} ./${PN} /opt/${PN} .

	insinto /usr/share/mime/packages
	doins "${FILESDIR}/${PN}-mimetypes.xml" || die

	domenu google-earth.desktop

	for size in 16 22 24 32 48 64 128 256 ; do
		newicon -s ${size} product_logo_${size}.png google-earth.png
	done

	rm -rf xdg-mime xdg-settings google-earth google-earth.desktop product_logo_*

	insinto /opt/${PN}
	doins -r *

	fperms +x /opt/${PN}/${PN}{,-bin}
	cd "${ED}" || die
	find . -type f -name "*.so.*" -exec fperms +x '{}' +

	pax-mark -m "${ED%/}"/opt/${PN}/${PN}-bin
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "When you get a crash starting Google Earth, try adding a file ~./.config/Google/GoogleEarthPlus.conf"
	elog "with the following options:"
	elog "lastTip = 4"
	elog "enableTips = false"
	elog ""
	elog "In addition, the use of free video drivers may cause problems associated with using the Mesa"
	elog "library. In this case, Google Earth 6x likely only works with the Gallium3D variant."
	elog "To select the 32bit graphic library use the command:"
	elog "	eselect mesa list"
	elog "For example, for Radeon R300 (x86):"
	elog "	eselect mesa set r300 2"
	elog "For Intel Q33 (amd64):"
	elog "	eselect mesa set 32bit i965 2"
	elog "You may need to restart X afterwards"

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
