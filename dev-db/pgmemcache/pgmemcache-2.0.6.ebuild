# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgmemcache/pgmemcache-2.0.6.ebuild,v 1.4 2014/12/28 15:10:00 titanofold Exp $

DESCRIPTION="A PostgreSQL API based on libmemcached to interface with memcached"
HOMEPAGE="http://pgfoundry.org/projects/pgmemcache"
SRC_URI="http://pgfoundry.org/frs/download.php/3018/${PN}_${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-db/postgresql-8.4
	dev-libs/cyrus-sasl
	>=dev-libs/libmemcached-0.39"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS || die "install documentation failed"
}
