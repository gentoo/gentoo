# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by qBittorrent"
HOMEPAGE="https://www.qbittorrent.org/download"
SRC_URI="https://github.com/qbittorrent/qBittorrent/raw/master/5B7CC9A2.asc -> qBittorrent-${PV}.asc"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

src_install() {
	insinto /usr/share/openpgp-keys
	newins "${DISTDIR}"/qBittorrent-${PV}.asc qBittorrent.asc
}
