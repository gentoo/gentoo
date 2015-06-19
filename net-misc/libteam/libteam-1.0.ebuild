# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/libteam/libteam-1.0.ebuild,v 1.2 2015/01/27 18:52:48 blueness Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit  autotools-utils linux-info

DESCRIPTION="Library and tools set for controlling team network device"
HOMEPAGE="https://fedorahosted.org/libteam/"
SRC_URI="https://github.com/jpirko/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug examples static-libs +syslog"

DEPEND="dev-libs/jansson
	dev-libs/libdaemon
	>=dev-libs/libnl-3.2.19[utils]
	sys-apps/dbus
	"
RDEPEND="${DEPEND}
	syslog? ( virtual/logger )"

CONFIG_CHECK="~NET_TEAM ~NET_TEAM_MODE_ROUNDROBIN ~NET_TEAM_MODE_ACTIVEBACKUP"
ERROR_NET_TEAM="NET_TEAM is not enabled in this kernel!
Only >=3.3.0 kernel version support in team mode"

DOCS=( HOWTO.BASICS README )

src_prepare() {
	# avoid using -Werror in CFLAGS
	sed -i -e '/^CFLAGS/s/-Werror//' configure.ac || die 'sed on CFLAGS failed'

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable syslog logging)
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
