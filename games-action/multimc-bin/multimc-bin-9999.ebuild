# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="An advanced Qt5-based open-source launcher for Minecraft"
HOMEPAGE="https://multimc.org https://github.com/MultiMC/Launcher"
SRC_URI="amd64? ( https://files.multimc.org/downloads/mmc-develop-lin64.tar.gz )
		x86? ( https://files.multimc.org/downloads/mmc-develop-lin32.tar.gz )"
# We need -bin because of secret API keys:
# https://github.com/MultiMC/Launcher/issues/4087
# https://github.com/MultiMC/Launcher/issues/4113
# https://bugs.gentoo.org/814404
S="${WORKDIR}"

LICENSE="Apache-2.0 Boost-1.0 BSD-2 BSD GPL-3 GPL-2+ LGPL-2.1-with-linking-exception LGPL-3 OFL-1.1 MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

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
"

QA_PREBUILT="*"

src_install() {
	pushd "${WORKDIR}/MultiMC/bin"

	insinto /usr/lib/multimc
	doins -r *

	popd

	exeinto /usr/lib/multimc
	newexe "${FILESDIR}/wrapper.sh" "multimc"

	fperms +x /usr/lib/multimc/MultiMC

	doicon -s scalable "${FILESDIR}/multimc.svg"

	domenu "${FILESDIR}/multimc.desktop"
}
