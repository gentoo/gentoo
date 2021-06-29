# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop edos2unix java-pkg-2 java-ant-2

DESCRIPTION="Unofficial online version of the Classic BattleTech board game"
HOMEPAGE="https://megamek.org/"
SRC_URI="
	mirror://sourceforge/${PN}/MegaMek-v${PV}.zip
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="app-arch/unzip"

src_prepare() {
	default

	rm MegaMek.jar || die

	sed -e "s|XmX|Xmx|" \
		-e "s|/usr/share/java|${EPREFIX}/usr/share/${PN}|" \
		-e "s|/usr/share/MegaMek|${EPREFIX}/usr/share/${PN}|" \
		startup.sh > ${PN} || die
	edos2unix ${PN}

	# workaround encoding issues posing problems with >=jdk-1.8
	find . -name '*.java' -exec sed -i 's/\xf6/\xc3\xb6/' {} + || die

	java-pkg-2_src_prepare
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r MegaMek.jar data docs l10n lib mmconf readme* # readme used at runtime

	dodoc HACKING readme.txt

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} MegaMek
}
