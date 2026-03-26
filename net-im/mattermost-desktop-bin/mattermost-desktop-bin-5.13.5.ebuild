# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-*}"
MY_PV="${PV/_rc/-rc.}"

inherit desktop toolchain-funcs xdg

DESCRIPTION="Mattermost Desktop application"
HOMEPAGE="https://mattermost.com/"

SRC_URI="
	amd64? ( https://releases.mattermost.com/desktop/${MY_PV}/mattermost-desktop-${MY_PV}-linux-x64.tar.gz )
	arm64? ( https://releases.mattermost.com/desktop/${MY_PV}/mattermost-desktop-${MY_PV}-linux-arm64.tar.gz )
"
S="${WORKDIR}"

LICENSE="Apache-2.0 GPL-2+ LGPL-2.1+ MIT"
SLOT="0"
# Starting with 5.2.0 upstream dropped x86 for their binary release #879519
if [[ ${PV} != *rc* ]]; then
	KEYWORDS="~amd64 ~arm64"
fi

RDEPEND="
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
	virtual/libudev
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
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

BDEPEND="
	dev-util/debugedit
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

src_prepare() {
	default

	# file collision with FEATURES=splitdebug, see bug #961437
	tc-export OBJCOPY
	find . -type f ! -name '*$(*)*' -print0 | while IFS= read -r -d '' file; do
		if file "${file}" | grep -qE "ELF (32|64)-bit"; then
			${OBJCOPY} --remove-section .note.gnu.build-id "${file}" || die
			debugedit -b "${EPREFIX}/opt/${MY_PN}" -d "/usr/lib/debug" -i "${file}" || die
		fi
	done
}

src_install() {
	if use amd64; then
		cd mattermost-desktop-${MY_PV}-linux-x64 || die
	elif use arm64; then
		cd mattermost-desktop-${MY_PV}-linux-arm64 || die
	fi
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

	make_desktop_entry \
		"${MY_PN} --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto %U" \
		Mattermost "${MY_PN}" "Network;InstantMessaging;" \
		"MimeType=x-scheme-handler/mattermost;\nStartupWMClass=Mattermost"

	einstalldocs
}
