# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RPM_COMPRESS_TYPE=none
inherit rpm

MY_PV=$(ver_rs 2 '-')
MY_P="${PN}-${MY_PV}"
MY_PN="${PN/cd/CD}"

DESCRIPTION="Commandline FLAC CDDA authenticity verifier"
HOMEPAGE="http://en.true-audio.com"
SRC_URI="http://en.true-audio.com/ftp/${MY_P}.i586.rpm -> ${P}.rpm"
S="${WORKDIR}/usr/local/bin"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"

QA_PREBUILT="opt/bin/.*"

src_install() {
	into /opt
	dobin auCDtect
}
