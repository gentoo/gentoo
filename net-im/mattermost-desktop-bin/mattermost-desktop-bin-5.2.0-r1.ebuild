# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-*}"
MY_PV="${PV/_rc/-rc}"

PYTHON_COMPAT=( python3_{8..11} )
inherit desktop python-single-r1 xdg

DESCRIPTION="Mattermost Desktop application"
HOMEPAGE="https://mattermost.com/"

SRC_URI="https://releases.mattermost.com/desktop/${MY_PV}/mattermost-desktop-${MY_PV}-linux-x64.tar.gz"

LICENSE="Apache-2.0 GPL-2+ LGPL-2.1+ MIT"
SLOT="0"
# Starting with 5.2.0 upstream dropped x86 for their binary release #879519
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=app-accessibility/at-spi2-core-2.46.0:2[X]
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"

QA_PREBUILT="
	opt/mattermost-desktop/mattermost-desktop
	opt/mattermost-desktop/libnode.so
	opt/mattermost-desktop/libffmpeg.so
	opt/mattermost-desktop/libGLESv2.so
	opt/mattermost-desktop/libEGL.so
	opt/mattermost-desktop/libvk_swiftshader.so
	opt/mattermost-desktop/libvulkan.so.1
	opt/mattermost-desktop/resources/*
"

DOCS=(
	NOTICE.txt
)

S="${WORKDIR}/mattermost-desktop-${MY_PV}-linux-x64"

src_install() {
	newicon app_icon.png ${MY_PN}.png

	insinto "/opt/${MY_PN}/locales"
	doins locales/*.pak

	insinto "/opt/${MY_PN}/resources"
	doins -r resources/*.asar*

	insinto "/opt/${MY_PN}"
	doins *.pak *.bin *.dat
	exeinto "/opt/${MY_PN}"
	doexe *.so *.so.* "${MY_PN}"

	dosym -r "/opt/${MY_PN}/${MY_PN}" "/usr/bin/${MY_PN}"
	pushd "${ED}" || die
	find "opt/${MY_PN}/resources" -type l -name python3 -exec dosym -r "${PYTHON}" "{}" \; || die
	popd || die

	make_desktop_entry "${MY_PN}" Mattermost "${MY_PN}"

	einstalldocs
}
