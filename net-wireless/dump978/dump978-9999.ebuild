# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="simple Mode S decoder for soapysdr supported devices"
HOMEPAGE="https://github.com/flightaware/dump978"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/flightaware/${PN}.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	#COMMIT="fb5942dba6505a21cbafc7905a5a7c513b214dc9"
	#SRC_URI="https://github.com/flightaware/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	#S="${WORKDIR}/${PN}-${COMMIT}"
	SRC_URI="https://github.com/flightaware/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/boost:=
		net-wireless/soapysdr:="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e 's#-Wall -Wno-psabi -Werror -O2 -g##' Makefile
}

src_install() {
	newbin ${PN}-fa ${PN}
	dobin skyaware978
	dodoc README.md

	insinto /usr/share/${PN}
	newins debian/lighttpd/89-skyaware978.conf lighttpd.conf
}
