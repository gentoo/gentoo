# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd

DESCRIPTION="iSNS server and client for Linux"
HOMEPAGE="https://github.com/open-iscsi/open-isns"
SRC_URI="https://github.com/open-iscsi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="ssl static"

DEPEND="
	ssl? (
		dev-libs/openssl:=
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static both shared)
		-Dslp=disabled
		-Dsystemddir=$(systemd_get_utildir)
		$(meson_feature ssl security)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	keepdir /var/lib/${PN/open-}
}
