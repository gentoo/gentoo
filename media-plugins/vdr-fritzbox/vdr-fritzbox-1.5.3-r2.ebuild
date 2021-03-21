# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Inform about incoming phone-calls and use the fritz!box phonebook"
HOMEPAGE="https://github.com/jowi24/vdr-fritz"
SRC_URI="https://github.com/jowi24/vdr-fritz/releases/download/${PV}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libgcrypt:0
	dev-libs/boost[threads]
	media-video/vdr"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-boost-1.67.patch" )

src_prepare() {
	vdr-plugin-2_src_prepare

	# do not call ar directly
	export _VDRAR="$(tc-getAR)"
	sed -e "s:\@ar :\@\$(_VDRAR) :" \
		-i libconv++/Makefile \
		-i libfritz++/Makefile \
		-i liblog++/Makefile \
		-i libnet++/Makefile || die
}

pkg_postinst() {
	elog "It is recommend to update your firmware release to the latest."
	elog
	elog "The integrated call monitor (available in Fritz!Box official"
	elog "firmware releases >= *.04.29) has to be enabled in order to"
	elog "have the vdr-fritzbox plugin display anything on your tv. To"
	elog "enable it call #96*5* from your telephone. If that doesn't"
	elog "work for you, read the documentation for further instructions."
}
