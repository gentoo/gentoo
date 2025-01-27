# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( 13 14 15 16 17 )

RESTRICT="test"

DESCRIPTION="PostgreSQL Replication Manager"
HOMEPAGE="http://www.repmgr.org/"
SRC_URI="https://github.com/EnterpriseDB/repmgr/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

inherit postgres-multi

DEPEND="${POSTGRES_DEPS}
	dev-libs/json-c"
RDEPEND="${DEPEND}
	net-misc/rsync"

PATCHES=(
	"${FILESDIR}"/${PN}-5.1.0-fix-missing-getpwuid-clang16.patch
)

src_configure() {
	postgres-multi_foreach econf
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" USE_PGXS=1 install
	#emake DESTDIR="${D}" USE_PGXS=1 install
	dodoc CREDITS HISTORY COPYRIGHT *.md

	local PGSLOT="$(postgresql-config show)"
	einfo "PGSLOT: ${PGSLOT}"

	dodir /usr/share/postgresql-${PGSLOT}/contrib
	dodir /usr/$(get_libdir)/postgresql-${PGSLOT}

	insinto /etc
	newins repmgr.conf.sample repmgr.conf

	fowners postgres:postgres /etc/repmgr.conf
	ewarn "Remember to modify /etc/repmgr.conf"
}
