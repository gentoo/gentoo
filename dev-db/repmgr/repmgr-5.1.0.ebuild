# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils multilib
DESCRIPTION="PostgreSQL Replication Manager"
HOMEPAGE="http://www.repmgr.org/"
SRC_URI="http://www.repmgr.org/download/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=">=dev-db/postgresql-9.3[server,static-libs]"
RDEPEND="${DEPEND}
	net-misc/rsync"

src_compile() {
	emake USE_PGXS=1
}

src_install() {
	emake DESTDIR="${D}" USE_PGXS=1 install
	export PGSLOT="$(postgresql-config show)"
	einfo "PGSLOT: ${PGSLOT}"
	PGBASEDIR=/usr/$(get_libdir)/postgresql-${PGSLOT}
	PGBINDIR=${PGBASEDIR}/bin/
	PGCONTRIB=/usr/share/postgresql-${PGSLOT}/contrib/
	dodir $PGCONTRIB $PGBINDIR
	dosym $PGBINDIR/repmgr /usr/bin/repmgr${PGSLOT//.}
	dosym $PGBINDIR/repmgrd /usr/bin/repmgrd${PGSLOT//.}
	dodoc  CREDITS HISTORY COPYRIGHT *.md
	insinto /etc
	newins repmgr.conf.sample repmgr.conf
	fowners postgres:postgres /etc/repmgr.conf
	ewarn "Remember to modify /etc/repmgr.conf"
}
