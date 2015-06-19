# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgmemcache/pgmemcache-2.1.1.ebuild,v 1.3 2014/12/28 15:10:00 titanofold Exp $

EAPI=5

DESCRIPTION="A PostgreSQL API based on libmemcached to interface with memcached"
HOMEPAGE="http://pgfoundry.org/projects/pgmemcache"
SRC_URI="http://pgfoundry.org/frs/download.php/3018/${PN}_${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-db/postgresql-8.4
	dev-libs/cyrus-sasl
	<dev-libs/libmemcached-1[sasl]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
