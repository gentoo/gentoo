# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils versionator

IUSE="doc perl"

DESCRIPTION="A replication system for the PostgreSQL Database Management System"
HOMEPAGE="http://slony.info/"

# ${P}-docs.tar.bz2 contains man pages as well as additional documentation
MAJ_PV=$(get_version_component_range 1-2)
SRC_URI="http://main.slony.info/downloads/${MAJ_PV}/source/${P}.tar.bz2
		 http://main.slony.info/downloads/${MAJ_PV}/source/${P}-docs.tar.bz2"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="|| (
			dev-db/postgresql:9.6
			dev-db/postgresql:9.5
			dev-db/postgresql:9.4
			dev-db/postgresql:9.3
			dev-db/postgresql:9.2
			dev-db/postgresql:9.1
		)
		dev-db/postgresql[server,threads]
		perl? ( dev-perl/DBD-Pg )
"

pkg_setup() {
	local PGSLOT="$(postgresql-config show)"
	if [[ ${PGSLOT//.} < 91 ]] ; then
		eerror "You must build ${CATEGORY}/${PN} against PostgreSQL 9.1 or higher."
		eerror "Set an appropriate slot with postgresql-config."
		die "postgresql-config not set to 9.1 or higher."
	fi
}

src_configure() {
	local myconf
	use perl && myconf='--with-perltools'
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc INSTALL README SAMPLE TODO UPGRADING share/slon.conf-sample

	if use doc ; then
		cd "${S}"/doc
		dohtml -r *
	fi

	newinitd "${FILESDIR}"/slony1.init slony1
	newconfd "${FILESDIR}"/slony1.conf slony1
}
