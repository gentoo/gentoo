# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils flag-o-matic versionator

DESCRIPTION="Simple C-library to access Oracle databases via the OCI interface"
SRC_URI="http://www.poitschke.de/libsqlora8/${P}.tar.gz"
HOMEPAGE="http://www.poitschke.de/libsqlora8/index_noframe.html"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~x86"

IUSE="orathreads static-libs +threads"

RDEPEND="dev-db/oracle-instantclient"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

REQUIRED_USE="?? ( orathreads threads )"

src_configure() {
	local myconf

	local ORACLE_VER="$(best_version dev-db/oracle-instantclient)"
	ORACLE_VER="${ORACLE_VER#*/*-*-}" #reduce it to ${PV}-${PR}
	ORACLE_VER="$(get_version_component_range 1-2 ${ORACLE_VER})"
	append-ldflags -L"/usr/lib/oracle/${ORACLE_VER}/client/lib"

	use threads && myconf="--with-threads=posix"
	use orathreads && myconf="--with-threads=oracle"

	econf \
		$(use_enable static-libs static) \
		${myconf}
}

src_compile() {
	# Parallel compilation is not supported
	emake -j1
}

src_install () {
	default
	prune_libtool_files
	dodoc ChangeLog NEWS NEWS-2.2

	# TODO
	# Copy contents of doc and examples directory to proper place
	rm -r "${D}/usr/share/doc/packages"
}
