# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info systemd

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/jpirko/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/jpirko/libteam/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~hppa ~loong ppc ppc64 ~riscv x86"
fi

DESCRIPTION="Library and tools set for controlling team network device"
HOMEPAGE="https://libteam.org"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="dbus debug examples static-libs +syslog zmq"

DEPEND="
	>=dev-libs/jansson-2.4:=
	dev-libs/libdaemon
	>=dev-libs/libnl-3.2.19[utils]
	dbus? ( sys-apps/dbus )
	zmq? ( >=net-libs/zeromq-3.2.0 )
"
RDEPEND="${DEPEND}
	syslog? ( virtual/logger )
"

CONFIG_CHECK="~NET_TEAM ~NET_TEAM_MODE_ROUNDROBIN ~NET_TEAM_MODE_ACTIVEBACKUP ~NET_TEAM_MODE_BROADCAST ~NET_TEAM_MODE_RANDOM ~NET_TEAM_MODE_LOADBALANCE"
ERROR_NET_TEAM="NET_TEAM is not enabled in this kernel!
Only >=3.3.0 kernel version support in team mode"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable syslog logging)
		$(use_enable dbus)
		$(use_enable zmq)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die

	insinto /etc/dbus-1/system.d
	doins teamd/dbus/teamd.conf
	systemd_dounit teamd/redhat/systemd/teamd@.service

	if use examples; then
		docinto examples
		dodoc teamd/example_configs/*
	fi
}
