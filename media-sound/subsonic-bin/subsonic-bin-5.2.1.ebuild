# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/subsonic-bin/subsonic-bin-5.2.1.ebuild,v 1.1 2015/04/11 19:51:07 perfinion Exp $

EAPI=5

inherit eutils user

MY_PN="${PN//-bin}"

DESCRIPTION="Subsonic is a complete, personal media streaming solution"
HOMEPAGE="http://www.subsonic.org/"
SRC_URI="mirror://sourceforge/${MY_PN}/${PV}/${MY_PN}-${PV}-standalone.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ffmpeg lame"

DEPEND=""
RDEPEND="virtual/jre
	lame? ( media-sound/lame )
	ffmpeg? ( virtual/ffmpeg )"

S="${WORKDIR}/"
SUBSONIC_HOME="/var/lib/${MY_PN}"
USER_GROUP="subsonic"

pkg_setup() {
	enewgroup "${USER_GROUP}"
	enewuser "${USER_GROUP}" -1 -1 ${SUBSONIC_HOME} "${USER_GROUP}"
}

src_install() {
	local dir="/usr/share/${P}"

	dodoc README.TXT "Getting Started.html"

	insinto ${dir}
	doins subsonic-booter-jar-with-dependencies.jar subsonic.war

	exeinto ${dir}
	doexe subsonic.sh

	keepdir ${SUBSONIC_HOME}
	fowners ${USER_GROUP}:${USER_GROUP} ${SUBSONIC_HOME}

	newinitd "${FILESDIR}/subsonic.initd" subsonic
	newconfd "${FILESDIR}/subsonic.confd" subsonic

	make_wrapper ${MY_PN} "${dir}/subsonic.sh"

	if use ffmpeg; then
		dodir ${SUBSONIC_HOME}/transcode
		dosym /usr/bin/ffmpeg ${SUBSONIC_HOME}/transcode/ffmpeg
	fi

	if use lame; then
		dodir ${SUBSONIC_HOME}/transcode
		dosym /usr/bin/lame ${SUBSONIC_HOME}/transcode/lame
	fi
}
