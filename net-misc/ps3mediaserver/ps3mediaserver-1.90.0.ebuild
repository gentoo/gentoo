# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="DLNA compliant UPNP server for streaming media to Playstation 3"
HOMEPAGE="https://github.com/ps3mediaserver/ps3mediaserver"
SRC_URI="mirror://sourceforge/project/ps3mediaserver/pms-${PV}-generic-linux-unix.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="multiuser +transcode tsmuxer"

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.6.0
	media-libs/libmediainfo
	media-libs/libzen
	tsmuxer? ( media-video/tsmuxer )
	transcode? ( media-video/mplayer[encode] )"

S=${WORKDIR}/pms-${PV}
PMS_HOME=/opt/${PN}

src_prepare() {
	if use multiuser; then
		cat > ${PN} <<-EOF
		#!/bin/sh
		if [ ! -e ~/.${PN} ]; then
			echo "Copying ${PMS_HOME} to ~/.${PN}"
			cp -pPR "${PMS_HOME}" ~/.${PN}
		fi
		export PMS_HOME=\${HOME}/.${PN}
		exec "\${PMS_HOME}/PMS.sh" "\$@"
		EOF
	else
		cat > ${PN} <<-EOF
		#!/bin/sh
		export PMS_HOME=${PMS_HOME}
		exec "\${PMS_HOME}/PMS.sh" "\$@"
		EOF
	fi

	cat > ${PN}.desktop <<-EOF
	[Desktop Entry]
	Name=PS3 Media Server
	GenericName=Media Server
	Exec=${PN}
	Icon=${PN}
	Type=Application
	Categories=Network;
	EOF

	unzip -j pms.jar resources/images/icon-{32,256}.png || die
}

src_install() {
	dobin ${PN}

	exeinto ${PMS_HOME}
	doexe PMS.sh

	insinto ${PMS_HOME}
	doins -r pms.jar *.conf documentation plugins renderers *.xml
	use tsmuxer && dosym /opt/tsmuxer/bin/tsMuxeR ${PMS_HOME}/linux/tsMuxeR
	dodoc CHANGELOG.txt README.md

	newicon -s 32 icon-32.png ${PN}.png
	newicon -s 256 icon-256.png ${PN}.png

	domenu ${PN}.desktop

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		ewarn "Don't forget to disable transcoding engines for software"
		ewarn "that you don't have installed (such as having the VLC"
		ewarn "transcoding engine enabled when you only have mencoder)."
	elif use multiuser; then
		ewarn "Remember to refresh the files in ~/.ps3mediaserver/"
	fi
}
