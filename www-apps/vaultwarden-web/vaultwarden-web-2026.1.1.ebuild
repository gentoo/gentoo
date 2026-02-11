# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Prebuilt web vault frontend for Vaultwarden"
HOMEPAGE="https://github.com/dani-garcia/bw_web_builds"

SRC_URI="https://github.com/dani-garcia/bw_web_builds/releases/download/v${PV}/bw_web_v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/web-vault"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
# this package is really useless without vaultwarden, it cannot be run
# standalone, so pull in vaultwarden to run it
PDEPEND="app-admin/vaultwarden[web]"

src_install() {
	insinto /usr/share/webapps/"${PN}"
	doins -r *
}
