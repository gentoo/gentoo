# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-utils-2 xdg

DESCRIPTION="Java-based editor for the OpenStreetMap project"
HOMEPAGE="https://josm.openstreetmap.de/"
# PV should be stable here https://josm.openstreetmap.de/wiki/StartupPage
SRC_URI="https://josm.openstreetmap.de/download/josm-snapshot-${PV}.jar"
S="${WORKDIR}"

LICENSE="Apache-2.0 GPL-2+ GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8"
BDEPEND="app-arch/unzip"

src_install() {
	java-pkg_newjar "${DISTDIR}/${A}" ${PN}.jar
	java-pkg_dolauncher ${PN} --jar ${PN}.jar

	local icon_size
	for icon_size in 16 32 48; do
		newicon -s ${icon_size} -t hicolor \
			images/logo_${icon_size}x${icon_size}x32.png ${PN}.png
		newicon -s ${icon_size} -t locolor \
			images/logo_${icon_size}x${icon_size}x8.png ${PN}.png
	done
	make_desktop_entry ${PN} "Java OpenStreetMap Editor" ${PN} "Utility;Science;Geoscience"
}
