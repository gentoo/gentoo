# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs vdr-plugin-2

DESCRIPTION="VDR Plugin: Inform about incoming phone-calls and use the fritz!box phonebook"
HOMEPAGE="https://github.com/jowi24/vdr-fritz"
SRC_URI="https://github.com/jowi24/vdr-fritz/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/jowi24/libconvpp/archive/286a289e30417ac534c861529ae245ccb44286e5.tar.gz -> ${P}.libconvpp.tar.gz
	https://github.com/jowi24/libfritzpp/archive/c74fd462285ade1054784b97b6dce22d55196c01.tar.gz -> ${P}.libfritzpp.tar.gz
	https://github.com/jowi24/liblogpp/archive/d61e25f4548f40261e6db62a967776cfa16e599a.tar.gz -> ${P}.liblogpp.tar.gz
	https://github.com/jowi24/libnetpp/archive/b32ecc8e64508f3b1158a2adcbd82034c71d7a38.tar.gz -> ${P}.libnetpp.tar.gz"
S="${WORKDIR}/vdr-fritz-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libgcrypt:=
	dev-libs/boost:=
	media-video/vdr"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.3_clang.patch"
)

src_unpack() {
	default

	# source git repo has submodules, which are not included in main repo download.
	# so each submodule is loaded separately und must be moved to the right place after unpack
	mv libconvpp-*/* "${S}/libconv++/" || die
	mv libfritzpp-*/* "${S}/libfritz++/" || die
	mv liblogpp-*/* "${S}/liblog++/" || die
	mv libnetpp-*/* "${S}/libnet++/" || die
}

src_prepare() {
	vdr-plugin-2_src_prepare

	# do not call ar directly
	export _VDRAR="$(tc-getAR)"
	sed -e "s:\@ar :\@\$(_VDRAR) :" \
		-i libconv++/Makefile \
		-i libfritz++/Makefile \
		-i liblog++/Makefile \
		-i libnet++/Makefile || die

	# upstream author forgot to update version information
	sed -e "s:1.5.3:1.5.4:" -i fritzbox.cpp || die

	# remove non-functional tests, #934764
	rm -rf ./test/ ./lib*/test/ || die
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
