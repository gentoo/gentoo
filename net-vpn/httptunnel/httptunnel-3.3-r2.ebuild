# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="httptunnel can create IP tunnels through firewalls/proxies using HTTP"
HOMEPAGE="https://github.com/larsbrinkhoff/httptunnel"
SRC_URI="http://www.nocrew.org/software/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"

PATCHES=(
	"${FILESDIR}"/${P}-fix_write_stdin.patch
)
