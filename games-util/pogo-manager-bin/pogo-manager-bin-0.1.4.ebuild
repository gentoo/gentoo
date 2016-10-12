# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/-bin}"

DESCRIPTION="Pokemon Go manager"
HOMEPAGE="https://github.com/Wolfsblvt/BlossomsPokemonGoManager"
SRC_URI="https://github.com/Wolfsblvt/BlossomsPokemonGoManager/releases/download/v${PV}/BPGM_v${PV}.zip -> ${P}.zip"

LICENSE="CC-BY-NC-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( dev-java/oracle-jdk-bin:1.8[javafx] dev-java/oracle-jre-bin:1.8[javafx] )"
DEPEND="app-arch/unzip"

S="${WORKDIR}/BPGM_v${PV}"

src_install()
{
	insinto /opt/${MY_PN}
	newins BlossomsPogoManager.jar ${MY_PN}.jar

	dobin "${FILESDIR}/pogo-manager"
}

pkg_postinst()
{
	ewarn "Use of this tool is not sanctioned by Niantic and could get you banned."
	ewarn "You have been warned!"
}
