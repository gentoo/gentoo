# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT="385f9e4cda592ace95b47c69db76553bcb6a42d6"

DESCRIPTION="A Munin plugin for monitoring ZFS on Linux"
HOMEPAGE="https://github.com/alexclear/ZoL-munin-plugin"
SRC_URI="https://github.com/alexclear/ZoL-munin-plugin/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ZoL-munin-plugin-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="net-analyzer/munin"
RDEPEND="${DEPEND}
	sys-devel/bc

"

src_install() {
	dodoc README.md

	exeinto /usr/libexec/munin/plugins
	doexe zfs_stats_
}
