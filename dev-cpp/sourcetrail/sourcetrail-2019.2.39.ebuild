# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg-utils

DESCRIPTION="A cross-platform source explorer for C/C++ and Java"
HOMEPAGE="https://www.sourcetrail.com/"
SRC_URI="https://www.sourcetrail.com/downloads/${PV}/linux/64bit -> ${P}.tar.gz"

LICENSE="Sourcetrail || ( GPL-2 GPL-3 LGPL-3 ) BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples selinux"
RESTRICT="mirror bindist"

DEPEND="dev-util/patchelf"

RDEPEND="
	|| (
		dev-libs/openssl-compat:1.0.0
		=dev-libs/openssl-1.0*:*
	)
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng-compat:1.2
	sys-libs/libudev-compat
	virtual/opengl
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXxf86vm
	selinux? ( sys-libs/libselinux )
"

S="${WORKDIR}/Sourcetrail"
QA_PREBUILT="*"

src_install() {
	# This removes the rpath entries with $$ORIGIN
	# since they trigger warnings when merging
	for f in "Sourcetrail" "sourcetrail_indexer"; do
		rpath=$(patchelf --print-rpath "${f}" 2>/dev/null)
		new_rpath=${rpath//\$\$ORIGIN\/lib\/:/}
		patchelf --set-rpath "${new_rpath}" "${f}" || die
	done

	# Remove bundled libraries
	rm -f lib/libXi.so.6 lib/libXxf86vm.so.1 lib/libXrender.so.1 lib/libXfixes.so.3 lib/libXext.so.6 \
		lib/libXdamage.so.1 lib/libxcb* lib/libXau.so.6 lib/libX11-xcb.so.1 lib/libX11.so.6 \
		lib/libudev.so.0 lib/libEGL.so.1 lib/libgbm.so.1 lib/libglapi.so.0 lib/libGL.so.1 \
		lib/libdrm.so.2 lib/libfontconfig.so.1 lib/libfreetype.so.6 lib/libcrypto.so lib/libssl.so \
		lib/libpng12.so.0 lib/libselinux.so.1 || die
	insinto /opt/sourcetrail
	doins -r EULA.txt README data lib plugin
	use examples && doins -r user
	exeinto /opt/sourcetrail
	doexe Sourcetrail sourcetrail_indexer Sourcetrail.sh resetPreferences.sh
	into /opt
	newbin - sourcetrail <<-EOF
		#! /bin/sh
		exec /opt/sourcetrail/Sourcetrail.sh "\$@"
	EOF
	local size
	for size in 48 64 128 256 512; do
		newicon -s "${size}" "setup/share/icons/hicolor/${size}x${size}/apps/sourcetrail.png" \
			"sourcetrail.png"
	done
	sed -i -e 's|Exec=/usr/bin/sourcetrail|Exec=/opt/bin/sourcetrail|' \
	       -e 's/Utilities;//' "setup/share/applications/sourcetrail.desktop" \
	          "setup/share/applications/sourcetrail.desktop" || die
	domenu "setup/share/applications/sourcetrail.desktop"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
