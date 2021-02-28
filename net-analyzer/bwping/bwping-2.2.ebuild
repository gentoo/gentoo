# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A tool to measure bandwidth and RTT between two hosts using ICMP"
HOMEPAGE="https://bwping.sourceforge.io/"
SRC_URI="https://github.com/oleg-derevenetz/bwping/archive/RELEASE_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-RELEASE_${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

src_test() {
	[[ ${UID} = 0 ]] && default
}
