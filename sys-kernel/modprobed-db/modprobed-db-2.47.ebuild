# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Keeps track of EVERY kernel module ever used - useful for make localmodconfig"
HOMEPAGE="https://github.com/graysky2/modprobed-db"
SRC_URI="https://github.com/graysky2/modprobed-db/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

src_install() {
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}/usr" INITDIR_SYSTEMD="$(systemd_get_userunitdir)"
}
