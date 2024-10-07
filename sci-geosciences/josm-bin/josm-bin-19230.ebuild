# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-utils-2 xdg

DESCRIPTION="Java-based editor for the OpenStreetMap project"
HOMEPAGE="https://josm.openstreetmap.de/"
# PV should be stable here https://josm.openstreetmap.de/wiki/StartupPage
SRC_URI="
	https://josm.openstreetmap.de/download/josm-snapshot-${PV}.jar
	https://josm.openstreetmap.de/export/${PV}/josm/trunk/native/linux/tested/usr/share/applications/org.openstreetmap.josm.desktop -> ${P}.desktop
	https://josm.openstreetmap.de/export/${PV}/josm/trunk/native/linux/tested/usr/share/mime/packages/josm.xml \
		-> ${P}.mime.xml
"
S="${WORKDIR}"

LICENSE="Apache-2.0 GPL-2+ GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8"
BDEPEND="app-arch/unzip"

src_unpack() {
	default

	cp "${DISTDIR}/${P}.desktop" "org.openstreetmap.${PN}.desktop" || die
}

src_prepare() {
	default

	sed -i -e 's/^Exec=josm/Exec=josm-bin/' "org.openstreetmap.${PN}.desktop" || die
	sed -i -e 's/^Icon=org.openstreetmap.josm/Icon=org.openstreetmap.josm-bin/' "org.openstreetmap.${PN}.desktop" || die
}

src_install() {
	java-pkg_newjar "${DISTDIR}/josm-snapshot-${PV}.jar" ${PN}.jar
	java-pkg_dolauncher ${PN} --jar ${PN}.jar \
		--java_args "\
			--add-exports=java.base/sun.security.action=ALL-UNNAMED \
			--add-exports=java.desktop/com.sun.imageio.plugins.jpeg=ALL-UNNAMED \
			--add-exports=java.desktop/com.sun.imageio.spi=ALL-UNNAMED"

	local icon_size
	for icon_size in 16 32 48; do
		newicon -s ${icon_size} -t hicolor \
			images/logo_${icon_size}x${icon_size}x32.png "org.openstreetmap.${PN}.png"
		newicon -s ${icon_size} -t locolor \
			images/logo_${icon_size}x${icon_size}x8.png "org.openstreetmap.${PN}.png"
	done
	newicon -s scalable images/logo.svg "org.openstreetmap.${PN}.svg"
	domenu "${WORKDIR}/org.openstreetmap.${PN}.desktop"
	insinto /usr/share/mime/packages
	newins "${DISTDIR}/${P}.mime.xml" "${PN}.xml"
}
