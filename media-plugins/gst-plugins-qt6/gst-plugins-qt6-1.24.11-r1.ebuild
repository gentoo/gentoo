# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GST_ORG_MODULE=gst-plugins-good
GST_PLUGINS_MULTILIB=false
inherit gstreamer-meson

DESCRIPTION="Qt6 QML video sink plugin for GStreamer"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="X"

DEPEND="
	dev-qt/qtbase:6=[gui,opengl,wayland,X?]
	dev-qt/qtdeclarative:6[opengl]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[egl,opengl,wayland,X?]
"
RDEPEND="${DEPEND}"
RDEPEND+=" || ( >=dev-qt/qtbase-6.10:6[wayland] <dev-qt/qtwayland-6.10:6 )"
BDEPEND="
	dev-qt/qtbase:6
	dev-qt/qtshadertools:6
"

PATCHES=( "${FILESDIR}/${P}-kamoso.patch" ) # in >=1.26.3, bug #958983

src_configure() {
	local emesonargs=(
		$(meson_feature X qt-x11)
		-Dqt-egl=disabled
		-Dqt-wayland=enabled
	)
	gstreamer-meson_src_configure
}
