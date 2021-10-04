# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="An advanced Qt5-based open-source launcher for Minecraft"
HOMEPAGE="https://multimc.org https://github.com/MultiMC/MultiMC5"
SRC_URI="https://files.multimc.org/downloads/multimc_$(ver_rs 2 -).deb"
# We need -bin because of secret API keys:
# https://github.com/MultiMC/MultiMC5/issues/4087
# https://github.com/MultiMC/MultiMC5/issues/4113
# https://bugs.gentoo.org/814404
S="${WORKDIR}"

KEYWORDS="-* ~amd64"
LICENSE="Apache-2.0 Boost-1.0 BSD-2 BSD GPL-2+ LGPL-2.1-with-linking-exception LGPL-3 OFL-1.1 MIT"
SLOT="0"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-qt/qtnetwork:5
	dev-qt/qtgui:5
	dev-qt/qttest:5
	dev-qt/qtxml:5
	sys-libs/zlib
	>=virtual/jre-1.8.0
	virtual/opengl
	x11-libs/libXrandr
"

QA_PREBUILT="*"

src_install() {
	mv "${S}"/* "${ED}" || die
	# Rename the .desktop file to avoid file conflict with non-bin version
	mv "${ED}/usr/share/applications/multimc.desktop" "${ED}/usr/share/applications/multimc-bin.desktop" || die
	# Change the name so we can differentiate from the non-bin version in app menu
	# and remove empty options
	sed -i \
		-e 's/Name=MultiMC 5/Name=MultiMC Official Binary/g' \
		-e '/Path=/d' \
		-e '/TerminalOptions=/d' \
		"${ED}/usr/share/applications/multimc-bin.desktop" || die
}
