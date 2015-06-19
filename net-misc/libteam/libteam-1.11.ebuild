# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/libteam/libteam-1.11.ebuild,v 1.6 2015/03/15 11:55:31 pacho Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils linux-info

DESCRIPTION="Library and tools set for controlling team network device"
HOMEPAGE="http://libteam.org"
SRC_URI="http://libteam.org/files/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="dbus debug examples static-libs +syslog"

DEPEND=">=dev-libs/jansson-2.4
	dev-libs/libdaemon
	>=dev-libs/libnl-3.2.19[utils]
	dbus? ( sys-apps/dbus )
	"
RDEPEND="${DEPEND}
	syslog? ( virtual/logger )"

CONFIG_CHECK="~NET_TEAM ~NET_TEAM_MODE_ROUNDROBIN ~NET_TEAM_MODE_ACTIVEBACKUP"
ERROR_NET_TEAM="NET_TEAM is not enabled in this kernel!
Only >=3.3.0 kernel version support in team mode"

DOCS=( README )

src_prepare() {
	# avoid using -Werror in CFLAGS
	sed -i -e '/^CFLAGS/s/-Werror//' configure.ac || die 'sed on CFLAGS failed'

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable syslog logging)
		$(use_enable dbus)
		--disable-zmq
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	insinto /etc/dbus-1/system.d
	doins teamd/dbus/teamd.conf

	if use examples; then
		docinto examples
		dodoc teamd/example_configs/*
	fi
}
