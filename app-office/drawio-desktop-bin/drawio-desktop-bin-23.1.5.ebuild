# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	af am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW
"

inherit chromium-2 desktop unpacker xdg

DESCRIPTION="draw.io diagramming and whiteboarding desktop app"
HOMEPAGE="https://www.drawio.com/"

SRC_URI="
	amd64? ( https://github.com/jgraph/drawio-desktop/releases/download/v${PV}/drawio-amd64-${PV}.deb
		-> ${PN}-amd64-${PV}.deb )
	arm64? ( https://github.com/jgraph/drawio-desktop/releases/download/v${PV}/drawio-arm64-${PV}.deb
		-> ${PN}-arm64-${PV}.deb )
	https://raw.githubusercontent.com/jgraph/drawio-desktop/bdf5a4de3331e8dabab2be4c8f7b1a5427118f3f/build/icon.svg
		-> drawio-${PV}-icon-r1.svg
"
S="${WORKDIR}"

KEYWORDS="-* ~amd64"

# These are the licenses used by node_modules packages, drawio and drawio-desktop repositories
LICENSE="
	0BSD Apache-2.0 BSD BSD-2 CC0-1.0 GPL-2 ISC PYTHON WTFPL-2 MIT ZLIB
"

SLOT="0"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	>=dev-libs/nss-3
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
"

QA_PREBUILT="opt/drawio/*"

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# cleanup languages
	pushd "opt/drawio/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	#Fix mimetype
	sed -i \
		-e 's*<icon name="x-office-document" />*<icon name="application-vnd.jgraph.mxfile"/>*g' \
		-e '4 i <sub-class-of type="text/xml"/>' \
		"usr/share/mime/packages/drawio.xml" || die "couldn't modify drawio.xml"
}

src_install() {
	local destdir="/opt/drawio"

	# Copy icons
	local IC_SIZE
	for IC_SIZE in 16 32 48 64 96 128 192 256 512 1024
	do
		newicon -s "${IC_SIZE}" "usr/share/icons/hicolor/${IC_SIZE}x${IC_SIZE}/apps/drawio.png" drawio.png
		newicon -s "${IC_SIZE}" -c mimetypes "usr/share/icons/hicolor/${IC_SIZE}x${IC_SIZE}/apps/drawio.png" \
		application-vnd.jgraph.mxfile.png
	done
	newicon -s scalable "${DISTDIR}/drawio-${PV}-icon-r1.svg" drawio.svg
	newicon -s scalable -c mimetypes "${DISTDIR}/drawio-${PV}-icon-r1.svg" application-vnd.jgraph.mxfile.svg

	# Create a desktop entry and associate it with the drawio mime type
	domenu usr/share/applications/drawio.desktop

	# MIME descriptor for .drawio and .vsdx files
	insinto /usr/share/mime/packages
	doins "usr/share/mime/packages/drawio.xml"

	exeinto "${destdir}"
	doexe opt/drawio/chrome-sandbox opt/drawio/chrome_crashpad_handler opt/drawio/drawio opt/drawio/*.so*

	insinto "${destdir}"
	insopts -m0644
	doins opt/drawio/*.pak opt/drawio/*.bin opt/drawio/*.json opt/drawio/*.dat
	insopts -m0755
	doins -r opt/drawio/locales opt/drawio/resources

	dosym "${destdir}"/drawio /usr/bin/drawio
}
