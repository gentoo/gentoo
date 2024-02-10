# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

MY_PV="${PV//./-}"

DESCRIPTION="Mathematics software for geometry"
HOMEPAGE="https://www.geogebra.org"
SRC_URI="https://download.geogebra.org/installers/$(ver_cut 1-2)/GeoGebra-Linux64-Portable-${MY_PV}.zip
	https://dev.gentoo.org/~gyakovlev/distfiles/Geogebra.svg"

LICENSE="Geogebra CC-BY-NC-SA-3.0 GPL-3 Apache-2.0 BSD-2 BSD BSD-4 colt EPL-1.0 icu LGPL-2.1 LGPL-2.1+ MIT W3C || ( GPL-2 CDDL )"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	x11-libs/libxshmfence
	dev-libs/nss
	app-accessibility/at-spi2-core
	x11-libs/libdrm
	>=x11-libs/gtk+-3
	media-libs/alsa-lib
	net-print/cups
"
BDEPEND="
	app-arch/unzip
	media-libs/libpng
"
DEPEND="${RDEPEND}"

# no tests
RESTRICT="test"

QA_PREBUILT="*"

src_unpack() {
	default
	mv -v GeoGebra-linux-x64 "${P}" || die
}

src_install() {
	# Fix PNGs
	png_path="${S}/resources/app/node_modules/ref-napi/docs/images"
	pngfix --out=out.png "${png_path}/apple-touch-icon.png"
	mv -f out.png "${png_path}/apple-touch-icon.png" || die
	pngfix --out=out.png "${png_path}/apple-touch-icon-72x72.png"
	mv -f out.png "${png_path}/apple-touch-icon-72x72.png" || die
	pngfix --out=out.png "${png_path}/apple-touch-icon-114x114.png"
	mv -f out.png "${png_path}/apple-touch-icon-114x114.png" || die

	rm -r "${S}/resources/app/node_modules/ref-napi/prebuilds/linux-arm64"
	rm -r "${S}/resources/app/node_modules/ffi-napi/prebuilds/linux-arm64"

	insinto /opt/GeoGebra
	doins -r .

	dosym -r /opt/GeoGebra/GeoGebra /usr/bin/geogebra
	fperms 0755 /opt/GeoGebra/GeoGebra
	doicon "${DISTDIR}/Geogebra.svg"
	make_desktop_entry geogebra Geogebra Geogebra Science
}

src_test() {
	ewarn "package has no tests"
}
