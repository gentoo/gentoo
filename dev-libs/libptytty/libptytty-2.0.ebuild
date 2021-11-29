# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A library for mostly OS-independent handling of pty/tty/utmp/wtmp/lastlog"
HOMEPAGE="http://software.schmorp.de/pkg/libptytty.html"
SRC_URI="http://dist.schmorp.de/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~sparc"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0-rundir.patch
)

DOCS=( Changes README )
