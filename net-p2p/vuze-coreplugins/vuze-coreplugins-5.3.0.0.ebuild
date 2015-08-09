# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# don't forget to update these when bumping the version
PLUGINS_V=2.1.7  # http://www.vuze.com/plugins/details/azplugins
RATING_V=1.4.3   # http://www.vuze.com/plugins/details/azrating
UPDATER_V=1.9.1  # http://www.vuze.com/plugins/details/azupdater
UPNPAV_V=0.4.9   # http://www.vuze.com/plugins/details/azupnpav

PLUGINS_DIST=azplugins_${PLUGINS_V}.jar
RATING_DIST=azrating_${RATING_V}.jar
UPDATER_DIST=azupdater_${UPDATER_V}.zip
UPNPAV_DIST=azupnpav_${UPNPAV_V}.zip

ALLPLUGINS_URL="http://azureus.sourceforge.net/plugins"

DESCRIPTION="Core plugins for Vuze that are included in upstream distribution"
HOMEPAGE="http://www.vuze.com/"
SRC_URI="
	${ALLPLUGINS_URL}/${PLUGINS_DIST}
	${ALLPLUGINS_URL}/${RATING_DIST}
	${ALLPLUGINS_URL}/${UPDATER_DIST}
	${ALLPLUGINS_URL}/${UPNPAV_DIST}"
LICENSE="GPL-2 BSD"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="~net-p2p/vuze-${PV}"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	mkdir -p plugins/{azplugins,azrating,azupdater,azupnpav} || die
	cp "${DISTDIR}"/${PLUGINS_DIST} plugins/azplugins || die
	cp "${DISTDIR}"/${RATING_DIST} plugins/azrating || die
	cd "${WORKDIR}"/plugins/azupdater && unpack ${UPDATER_DIST} || die
	cd "${WORKDIR}"/plugins/azupnpav && unpack ${UPNPAV_DIST} || die
}

src_compile() { :; }

src_install() {
	insinto /usr/share/vuze/
	doins -r "${WORKDIR}/plugins"
}
