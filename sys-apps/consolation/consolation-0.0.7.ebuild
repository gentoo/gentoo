# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd autotools

DESCRIPTION="libinput based console mouse daemon"
HOMEPAGE="https://salsa.debian.org/consolation-team/consolation"
SRC_URI="https://salsa.debian.org/consolation-team/${PN}/-/archive/${P}/${PN}-${P}.tar.gz"

LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libinput:=
	virtual/libudev:=
	dev-libs/libevdev:="
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/help2man"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}/consolation-0.0.7-makefile.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}-initd" ${PN}
	newconfd "${FILESDIR}/${PN}-confd" ${PN}

	systemd_dounit consolation.service
}
