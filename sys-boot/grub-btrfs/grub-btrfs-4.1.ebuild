# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Include btrfs snapshots at boot options (Grub menu)"
HOMEPAGE="https://github.com/Antynea/grub-btrfs"
SRC_URI="https://github.com/Antynea/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="systemd"

RDEPEND="sys-boot/grub:2"

PATCHES=(
	"${FILESDIR}/modular-installation.patch"
	"${FILESDIR}/gentoo-config.patch"
)

src_compile() {
	:
}

src_install() {
	default

	if use systemd; then
		emake DESTDIR="${D}" install-service
	fi
}
