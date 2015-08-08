# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A PostgreSQL API based on libmemcached to interface with memcached"
HOMEPAGE="http://pgfoundry.org/projects/pgmemcache https://github.com/ohmu/pgmemcache"
SRC_URI="https://github.com/ohmu/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql
	dev-libs/cyrus-sasl
	>=dev-libs/libmemcached-1.0.18[sasl]"
RDEPEND="${DEPEND}"

DOCS=( NEWS README TODO )

src_install() {
	emake -j1 DESTDIR="${D}" install
}
