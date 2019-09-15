# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Official ODBC driver for PostgreSQL"
HOMEPAGE="https://www.postgresql.org/"
SRC_URI="https://ftp.postgresql.org/pub/odbc/versions/src/${P}.tar.gz"
SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="amd64 x86"
IUSE="doc iodbc ssl threads"

DEPEND="dev-db/postgresql:*[ssl?]
		!iodbc? ( dev-db/unixODBC )
		iodbc? ( dev-db/libiodbc )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with iodbc) \
		$(use_with !iodbc unixodbc) \
		$(use_enable threads pthreads)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc readme.txt
	use doc && dodoc docs/*{html,jpg,txt}
}
