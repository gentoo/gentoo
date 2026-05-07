# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Modern IPv4/IPv6 ipcalc tool"
HOMEPAGE="https://gitlab.com/ipcalc/ipcalc"
MY_P="ipcalc-${PV}"
SRC_URI="
	https://gitlab.com/ipcalc/ipcalc/-/archive/${PV}/${MY_P}.tar.bz2
	https://dev.gentoo.org/~floppym/dist/ipcalc.1-1.0.2.bz2
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="geoip"

DEPEND="
	geoip? ( dev-libs/libmaxminddb )
"
RDEPEND="${DEPEND}
	!net-misc/ipcalc
"

src_configure() {
	local emesonargs=(
		$(meson_feature geoip use_maxminddb)
		-Duse_geoip=disabled
		-Duse_runtime_linking=disabled
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	newman "${WORKDIR}/ipcalc.1-1.0.2" ipcalc.1
}
