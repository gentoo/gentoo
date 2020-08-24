# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

COMMIT_LANG="4ba6f824e9c34565e61340d25bc8c3cc004d40fb"
COMMIT_MAPS="1d3401a37a3334e311faf18a22aeff0e0ac9ee65"
inherit cmake desktop python-any-r1 xdg-utils

DESCRIPTION="Online multi-player platform 2D shooter"
HOMEPAGE="https://www.teeworlds.com/"
SRC_URI="
	https://github.com/ktrace/gentoo-blobs/raw/master/teeworlds.png
	https://github.com/teeworlds/teeworlds/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/teeworlds/teeworlds-maps/archive/${COMMIT_MAPS}.tar.gz -> ${P}-maps.tar.gz
	https://github.com/teeworlds/teeworlds-translation/archive/${COMMIT_LANG}.tar.gz -> ${P}-translation.tar.gz
"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated"

RDEPEND="
	!dedicated? (
		app-arch/bzip2:=
		media-libs/freetype
		media-libs/libsdl[X,sound,opengl,video]
		media-libs/pnglite
		media-sound/wavpack
		virtual/glu
		virtual/opengl
		x11-libs/libX11
	)
	dev-libs/openssl:0=
	sys-libs/zlib"

DEPEND="${RDEPEND} ${PYTHON_DEPS}"

src_prepare() {
	cmake_src_prepare
	rm -r "${S}/datasrc/languages" || die
	rm -r "${S}/datasrc/maps" || die
	mv "${WORKDIR}/${PN}-translation-${COMMIT_LANG}" "${S}/datasrc/languages" || die
	mv "${WORKDIR}/${PN}-maps-${COMMIT_MAPS}" "${S}/datasrc/maps" || die
	cp "${DISTDIR}/${PN}.png" "${S}/" || die
	python_fix_shebang scripts/
}

src_configure() {
	local mycmakeargs=(
		-DCLIENT=$(usex dedicated OFF ON)
		-DDEV=$(usex debug ON OFF)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doicon -s 256 "${PN}.png"
	domenu other/teeworlds.desktop
	newinitd "${FILESDIR}"/${PN}-init.d ${PN}
	insinto "/etc/${PN}"
	doins "${FILESDIR}"/teeworlds_srv.cfg
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
