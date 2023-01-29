# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit wrapper

MY_PN="${PN//-bin}"
MY_P="subsonic-${PV}-standalone"

DESCRIPTION="Subsonic is a complete, personal media streaming solution"
HOMEPAGE="http://www.subsonic.org/"
SRC_URI="https://downloads.sourceforge.net/project/subsonic/subsonic/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg lame selinux"

RDEPEND="
	acct-group/subsonic
	acct-user/subsonic
	virtual/jre
	lame? ( media-sound/lame )
	ffmpeg? ( media-video/ffmpeg )
	selinux? ( sec-policy/selinux-subsonic )
"

S="${WORKDIR}"

src_install() {
	local dir="/usr/libexec/${MY_PN}"

	dodoc README.TXT "Getting Started.html"

	insinto ${dir}
	doins subsonic-booter-jar-with-dependencies.jar subsonic.war

	exeinto ${dir}
	doexe subsonic.sh

	newinitd "${FILESDIR}/subsonic.initd" subsonic
	newconfd "${FILESDIR}/subsonic.confd" subsonic

	make_wrapper ${MY_PN} "${dir}/subsonic.sh"

	if use ffmpeg; then
		keepdir /var/lib/subsonic/transcode
		dosym ../../../../../usr/bin/ffmpeg /var/lib/subsonic/transcode/transcode/ffmpeg
	fi

	if use lame; then
		keepdir /var/lib/subsonic/transcode/transcode
		dosym ../../../../../usr/bin/lame /var/lib/subsonic/transcode/transcode/lame
	fi
}
