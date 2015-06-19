# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/thermald/thermald-1.3.ebuild,v 1.1 2015/04/02 05:32:42 dlan Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils systemd

DESCRIPTION="Thermal daemon for Intel architectures"
HOMEPAGE="https://01.org/linux-thermal-daemon"
SRC_URI="https://github.com/01org/thermal_daemon/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
S=${WORKDIR}/thermal_daemon-${PV}

CDEPEND="dev-libs/dbus-glib
	dev-libs/libxml2"
DEPEND="${CDEPEND}
	sys-apps/sed"
RDEPEND="${CDEPEND}"

DOCS=( thermal_daemon_usage.txt README.txt )

src_configure() {
	local myeconfargs=(
	--with-systemdsystemunitdir=$(systemd_get_unitdir)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	rm -rf "${D}"/etc/init || die
	doinitd "${FILESDIR}"/thermald
}
