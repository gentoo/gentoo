# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ALSA ucm configuration files"
HOMEPAGE="https://www.alsa-project.org"
SRC_URI="https://www.alsa-project.org/files/pub/lib/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~riscv ~sparc ~x86"
IUSE=""

RDEPEND="!<media-libs/alsa-lib-1.2.1"
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/alsa
	doins -r ucm{,2}
}
