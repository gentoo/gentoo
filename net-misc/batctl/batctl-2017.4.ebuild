# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info toolchain-funcs

DESCRIPTION="BATMAN advanced control and management tool"
HOMEPAGE="https://www.open-mesh.org/"
SRC_URI="https://downloads.open-mesh.org/batman/releases/batman-adv-${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/libnl:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	if ( linux_config_exists && linux_chkconfig_present BATMAN_ADV ) \
		|| ! has_version net-misc/batman-adv ; then
		ewarn "You need the batman-adv kernel module,"
		ewarn "either from the kernel tree or via net-misc/batman-adv"
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" V=1 REVISION=gentoo-"${PVR}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	dodoc README.rst
}
