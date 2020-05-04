# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

MY_PN="${PN//-bin}"

DESCRIPTION="Subsonic is a complete, personal media streaming solution"
HOMEPAGE="http://www.subsonic.org/"
SRC_URI="mirror://sourceforge/${MY_PN}/${PV}/${MY_PN}-${PV}-standalone.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ffmpeg +lame selinux"

DEPEND=""
RDEPEND="
	acct-group/subsonic
	acct-user/subsonic
	virtual/jre
	lame? ( media-sound/lame )
	ffmpeg? ( media-video/ffmpeg )
	selinux? ( sec-policy/selinux-subsonic )
"

S=${WORKDIR}
SUBSONIC_HOME="/var/lib/${MY_PN}"

src_install() {
	local dir="/usr/libexec/${MY_PN}"

	dodoc README.TXT "Getting Started.html"

	insinto ${dir}
	doins subsonic-booter-jar-with-dependencies.jar subsonic.war

	exeinto ${dir}
	doexe subsonic.sh

	keepdir ${SUBSONIC_HOME}
	fowners subsonic:subsonic ${SUBSONIC_HOME}

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
