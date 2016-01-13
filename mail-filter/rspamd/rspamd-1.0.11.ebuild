# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils user

DESCRIPTION="Rapid spam filtering system"
SRC_URI="https://rspamd.com/downloads/${P}.tar.xz"
HOMEPAGE="https://github.com/vstakhov/rspamd"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl
		dev-libs/libpcre
		dev-lang/luajit:2
		dev-libs/libevent
		dev-db/sqlite:3
		dev-libs/glib:2
		dev-libs/gmime
		dev-libs/hiredis"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup rspamd
	enewuser rspamd -1 -1 /var/lib/rspamd rspamd
}

src_configure() {
	local mycmakeargs=(
		-DCONFDIR=/etc/rspamd
		-DRUNDIR=/var/run/rspamd
		-DDBDIR=/var/lib/rspamd
		-DLOGDIR=/var/log/rspamd
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}/rspamd.init" rspamd

	dodir /var/lib/rspamd
	dodir /var/log/rspamd

	fowners rspamd:rspamd /var/lib/rspamd /var/log/rspamd

	insinto /etc/logrotate.d
	newins "${FILESDIR}/rspamd.logrotate" rspamd
}
