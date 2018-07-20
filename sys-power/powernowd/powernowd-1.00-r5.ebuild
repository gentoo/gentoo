# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit linux-info systemd toolchain-funcs

DESCRIPTION="Daemon to control the speed and voltage of CPUs"
HOMEPAGE="http://www.deater.net/john/powernowd.html https://github.com/clemej/powernowd"
SRC_URI="http://www.deater.net/john/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
PATCHES=(
	"${FILESDIR}"/${P}-buf.patch
	"${FILESDIR}"/${P}-inline.patch
)

pkg_setup() {
	CONFIG_CHECK="~CPU_FREQ"
	WARNING_CPU_FREQ="Powernowd needs CPU_FREQ turned on!"
	linux-info_pkg_setup
}

src_prepare() {
	default
	rm -f Makefile
	tc-export CC
}

src_compile() {
	emake powernowd
}

src_install() {
	dosbin powernowd
	dodoc README

	newconfd "${FILESDIR}"/powernowd.confd powernowd
	newinitd "${FILESDIR}"/powernowd.initd powernowd
	systemd_dounit "${FILESDIR}"/${PN}.service
}
