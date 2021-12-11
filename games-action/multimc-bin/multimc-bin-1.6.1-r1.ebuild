# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="An advanced Qt5-based open-source launcher for Minecraft"
HOMEPAGE="https://multimc.org https://github.com/MultiMC/Launcher"
SRC_URI="https://files.multimc.org/downloads/multimc_$(ver_rs 2 -).deb"
# We need -bin because of secret API keys:
# https://github.com/MultiMC/Launcher/issues/4087
# https://github.com/MultiMC/Launcher/issues/4113
# https://bugs.gentoo.org/814404
S="${WORKDIR}"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="Apache-2.0 Boost-1.0 BSD-2 BSD GPL-3 GPL-2+ LGPL-2.1-with-linking-exception LGPL-3 OFL-1.1 MIT"
SLOT="0"

# Despite the open source nature of the app, there is quite a large discrepancy
# between the sources and the prebuilt binaries (source built versions of the
# app are not usable due to missing keys/files). We restrict bindist to be on
# the safe side (added files/keys are of unknown license).
RESTRICT="bindist"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qttest:5
	dev-qt/qtxml:5
	gnome-extra/zenity
	sys-libs/zlib
	>=virtual/jre-1.8.0
	virtual/opengl
	x11-libs/libXrandr
	!games-action/multimc
"

QA_PREBUILT="*"

src_prepare() {
	default
	# Remove empty/deprecated options
	sed -i \
		-e '/Path=/d' \
		-e '/TerminalOptions=/d' \
		"usr/share/applications/multimc.desktop" || die
}

src_install() {
	mv "${S}"/* "${ED}" || die
	# add link to launch from PATH
	dosym ../multimc/run.sh /opt/bin/multimc
}
