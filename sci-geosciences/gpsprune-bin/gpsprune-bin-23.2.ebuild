# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2 java-pkg-simple

DESCRIPTION="An application for viewing, editing and converting GPS data"
HOMEPAGE="https://activityworkshop.net/software/gpsprune/index.html"
SRC_URI="https://activityworkshop.net/software/gpsprune/gpsprune_${PV}.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-11:*"

S="${WORKDIR}"

JAVA_JAR_FILENAME="gpsprune.jar"
JAVA_MAIN_CLASS="tim.prune.GpsPrune"
JAVA_LAUNCHER_FILENAME="gpsprune"

src_prepare() {
	default

	cp "${DISTDIR}/gpsprune_${PV}.jar" gpsprune.jar || die
}

src_compile() {
	:
}

src_install() {
	java-pkg-simple_src_install

	for size in 128 96 72 64 48 36 32 24 22 16; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		newins "tim/prune/gui/images/window_icon_${size}.png" gpsprune.png
	done

	newmenu - gpsprune.desktop <<-EOF
		[Desktop Entry]
		Name=GpsPrune
		Type=Application
		Comment=Application for viewing, editing and converting coordinate data from GPS systems
		Exec=gpsprune
		Icon=gpsprune
		Categories=Science;Geoscience;
	EOF
}
