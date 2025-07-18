# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A PostgreSQL API based on libmemcached to interface with memcached"
HOMEPAGE="http://pgfoundry.org/projects/pgmemcache https://github.com/ohmu/pgmemcache"
SRC_URI="https://github.com/ohmu/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-db/postgresql
	dev-libs/cyrus-sasl
	|| (
		dev-libs/libmemcached-awesome[sasl]
		>=dev-libs/libmemcached-1.0.18[sasl]
	)
"
RDEPEND="${DEPEND}"

src_install() {
	emake -j1 DESTDIR="${D}" install
	einstalldocs
}
