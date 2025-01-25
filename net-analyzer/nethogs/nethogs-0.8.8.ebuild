# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps meson

DESCRIPTION="Small 'net top' tool, grouping bandwidth by process"
HOMEPAGE="https://github.com/raboof/nethogs"
SRC_URI="https://github.com/raboof/nethogs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:=[cxx]
"
DEPEND="${RDEPEND}"

DOCS=( DESIGN README.decpcap.txt README.md )

FILECAPS=(
	cap_net_admin,cap_net_raw usr/sbin/nethogs
)

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.8-meson.patch
)

src_prepare() {
	default

	cat <<-EOF > determineVersion.sh || die
	#!/bin/sh
	printf "${PV}"
	EOF
	chmod +x determineVersion.sh || die
}
