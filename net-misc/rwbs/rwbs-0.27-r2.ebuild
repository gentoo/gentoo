# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Roger Wilco base station"
HOMEPAGE="http://rogerwilco.gamespy.com/"
SRC_URI="http://games.gci.net/pub/VoiceOverIP/RogerWilco/rwbs_Linux_$(ver_rs 1-2 '_').tar.gz"

SLOT="0"
LICENSE="Resounding GPL-2"
KEYWORDS="~amd64 x86"
IUSE=""

# Everything is statically linked
DEPEND=""

S="${WORKDIR}"

QA_PREBUILT="opt/bin/rwbs"

src_install() {
	dodoc README.TXT CHANGES.TXT
	exeinto /opt/bin
	doexe rwbs run_rwbs

	# Put distribution into /usr/share/rwbs
	insinto /usr/share/rwbs/
	doins "${S}"/anotherpersonjoined "${S}"/helloandwelcome \
		"${S}"/ifucanhearthis "${S}"/invitetestxmit "${S}"/join?.rwc \
		"${S}"/plsstartagame "${S}"/thisisatestmsg

	newconfd "${FILESDIR}"/rwbs.conf rwbs
	newinitd "${FILESDIR}"/rwbs.rc rwbs
}
