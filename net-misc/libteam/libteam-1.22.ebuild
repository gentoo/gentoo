# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils linux-info

DESCRIPTION="Library and tools set for controlling team network device"
HOMEPAGE="http://libteam.org"
SRC_URI="http://libteam.org/files/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="dbus debug examples static-libs +syslog zmq"

DEPEND=">=dev-libs/jansson-2.4
	dev-libs/libdaemon
	>=dev-libs/libnl-3.2.19[utils]
	dbus? ( sys-apps/dbus )
	zmq? ( >=net-libs/zeromq-3.2.0 )
	"

RDEPEND="${DEPEND}
	syslog? ( virtual/logger )"

CONFIG_CHECK="~NET_TEAM ~NET_TEAM_MODE_ROUNDROBIN ~NET_TEAM_MODE_ACTIVEBACKUP ~NET_TEAM_MODE_BROADCAST ~NET_TEAM_MODE_RANDOM ~NET_TEAM_MODE_LOADBALANCE"
ERROR_NET_TEAM="NET_TEAM is not enabled in this kernel!
Only >=3.3.0 kernel version support in team mode"

DOCS=( README )

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable syslog logging)
		$(use_enable dbus)
		$(use_enable zmq)
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
