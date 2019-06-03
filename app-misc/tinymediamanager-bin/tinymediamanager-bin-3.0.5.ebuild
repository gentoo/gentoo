# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_P="${PN/-bin}-${PV%.*}"

DESCRIPTION="tinyMediaManager is a media management tool written in Java/Swing"
HOMEPAGE="https://www.tinymediamanager.org/"
SRC_URI="https://release.tinymediamanager.org/v3/dist/tmm_${PV}_linux.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/mediainfo
	virtual/jre:1.8"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto /opt/tinyMediaManager
	doins -r {lib,plugins,templates,progress.jpg,splashscreen.png,tmm.jar,tmm.png}

	exeinto /opt/tinyMediaManager
	newexe "${FILESDIR}/${MY_P}.sh" tinymediamanager
	dosym ../tinyMediaManager/tinymediamanager /opt/bin/tinymediamanager
	newexe "${FILESDIR}/${MY_P}-cli.sh" tinymediamanager-cli
	dosym ../tinyMediaManager/tinymediamanager-cli /opt/bin/tinymediamanager-cli

	domenu "${FILESDIR}"/tinymediamanager.desktop
}
