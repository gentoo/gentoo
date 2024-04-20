# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mount-boot

DESCRIPTION="Xbox boot loader precompiled binaries from xbox-linux.org"
HOMEPAGE="https://sourceforge.net/projects/xbox-linux/"
SRC_URI="mirror://sourceforge/xbox-linux/cromwell-${PV}.tar.gz"
S="${WORKDIR}/cromwell-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86"
RESTRICT="${RESTRICT} strip"

src_install() {
	insinto /boot/${PN}
	doins cromwell{,_1024}.bin xromwell.xbe
}
