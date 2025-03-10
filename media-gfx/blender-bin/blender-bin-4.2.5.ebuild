# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"
LICENSE="GPL-3+ Apache-2.0"
SLOT="${PV%.*}"
RESTRICT="strip"

if [[ ${PV} = *9999* ]] ; then
	BDEPEND="
		app-misc/jq
	"
	PROPERTIES+=" live"
else
	SRC_URI="
		https://download.blender.org/release/Blender${SLOT}/blender-${PV}-linux-x64.tar.xz
	"
	KEYWORDS="~amd64"
fi

RDEPEND="
media-libs/libglvnd
sys-libs/glibc
virtual/libcrypt
x11-base/xorg-server
"

src_unpack() {
	mkdir -p "${S}"
	if [[ ${PV} = *9999* ]] ; then
		if [[ -z "${BLENDER_BIN_URL}" ]]; then
			latest=$(wget -O - "https://builder.blender.org/download/daily/?format=json&v=1" | \
				jq -r 'map(select(.platform == "linux" and .branch == "main" and .file_extension == "xz")) | .[0].url' )
		else
			latest=$BLENDER_BIN_URL
		fi

		echo $latest

		wget -c "$latest" -O "${T}/blender_daily.tar.xz" || die
		tar xf "${T}/blender_daily.tar.xz" --directory "${S}" --strip-components=1 || die
	else
		tar xf "${DISTDIR}/blender-${PV}-linux-x64.tar.xz" --directory "${S}" --strip-components=1 || die
	fi
}

src_install() {
	declare BLENDER_OPT_HOME=/opt/${P}

	# Prepare icons and .desktop for menu entry
	mv blender.desktop ${P}.desktop
	mv blender.svg ${P}.svg
	mv blender-symbolic.svg ${P}-symbolic.svg
	sed -i -e "s:=blender:=${P}:" -e "s:Name=Blender:Name=Blender Bin ${PV}:" "${P}.desktop" || die

	# Install icons and .desktop for menu entry
	doicon -s scalable "${S}"/blender*.svg
	domenu ${P}.desktop

	# Install all the blender files in /opt
	dodir ${BLENDER_OPT_HOME%/*}
	mv "${S}" "${D}"${BLENDER_OPT_HOME} || die

	# Create symlink /usr/bin/blender-bin
	dosym ${BLENDER_OPT_HOME}/blender /usr/bin/${P}
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
