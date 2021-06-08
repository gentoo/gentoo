# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info toolchain-funcs

DESCRIPTION="BATMAN advanced control and management tool"
HOMEPAGE="https://www.open-mesh.org/"
SRC_URI="https://downloads.open-mesh.org/batman/releases/batman-adv-${PV}/${P}.tar.gz"

LICENSE="GPL-2 MIT ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="dev-libs/libnl:3"
DEPEND="${RDEPEND}"

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present BATMAN_ADV; then
		ewarn "batctl requires batman-adv kernel support"
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" V=1 REVISION="gentoo-${PVR}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc README.rst
}
