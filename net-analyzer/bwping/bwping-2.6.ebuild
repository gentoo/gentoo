# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A tool to measure bandwidth and RTT between two hosts using ICMP"
HOMEPAGE="https://bwping.sourceforge.io/"
SRC_URI="https://github.com/oleg-derevenetz/bwping/releases/download/RELEASE_${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~sparc ~x86"

src_test() {
	[[ ${UID} = 0 ]] && default
}
