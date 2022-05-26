# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="An application for viewing, editing and converting GPS data"
HOMEPAGE="http://activityworkshop.net/software/gpsprune/index.html"
SRC_URI="http://activityworkshop.net/software/gpsprune/gpsprune_${PV}.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/jre:*"
RDEPEND="${DEPEND}"

gpsprune_bin="${WORKDIR}/gpsprune"
gpsprune_desktop="${WORKDIR}/gpsprune.desktop"

S="${WORKDIR}"

src_prepare() {
	default

	# Provide the necessary files
	cp "${DISTDIR}/${A}" "${WORKDIR}" || die
	for size in 128 96 72 64 48 36 32 24 22 16; do
		mkdir -p "${WORKDIR}/icons/$size"
		cp "${WORKDIR}/tim/prune/gui/images/window_icon_${size}.png" "${WORKDIR}/icons/$size/gpsprune.png" || die
	done

	# Generate an executable
	cat <<-EOF > "${gpsprune_bin}" || die
	#!/bin/sh
	java -jar /opt/gpsprune/gpsprune_${PV}.jar \$@
	EOF

	# Generate a .desktop file
	cat <<-EOF > "${gpsprune_desktop}" || die
	[Desktop Entry]
	Name=GpsPrune
	Type=Application
	Comment=Application for viewing, editing and converting coordinate data from GPS systems
	Exec=gpsprune
	Icon=gpsprune
	Categories=Science;Geoscience;
	EOF
}

src_install() {
	insinto /opt/gpsprune
	doins "gpsprune_${PV}.jar"
	exeinto /usr/bin
	doexe "${gpsprune_bin}"

	for size in 128 96 72 64 48 36 32 24 22 16; do
		insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
		doins "icons/${size}/gpsprune.png"
	done

	domenu gpsprune.desktop
}
