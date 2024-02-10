# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="lightweight, extensible meta-backup system"
HOMEPAGE="https://0xacab.org/liberate/backupninja"
SRC_URI="https://0xacab.org/liberate/backupninja/-/archive/backupninja_upstream/${PV}/backupninja-backupninja_upstream-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-util/dialog"
DEPEND=""

S="${WORKDIR}/${PN}-${PN}_upstream-${PV}"

src_configure() {
	econf --localstatedir=/var #578614
}
