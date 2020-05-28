# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit readme.gentoo-r1

DESCRIPTION="Script to update DNS settings of an OpenVPN link through systemd-resolved"
HOMEPAGE="https://github.com/jonathanio/update-systemd-resolved"
SRC_URI="https://github.com/jonathanio/update-systemd-resolved/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	net-vpn/openvpn
	sys-apps/systemd
"

RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( LICENSE CHANGELOG.md README.md )

src_compile() {
	true
}

src_install() {
	default

	einstalldocs

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
