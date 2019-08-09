# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pirko/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/jpirko/libteam/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="Library and tools set for controlling team network device"
HOMEPAGE="http://libteam.org"

LICENSE="LGPL-2.1+"
SLOT="0"
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

src_prepare(){
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable syslog logging) \
		$(use_enable dbus) \
		$(use_enable zmq)
}

src_install() {
	default

	insinto /etc/dbus-1/system.d
	doins teamd/dbus/teamd.conf

	if use examples; then
		docinto examples
		dodoc teamd/example_configs/*
	fi
}
