# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

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
KEYWORDS="amd64 ppc x86"

DEPEND="|| (
			dev-db/postgresql:9.2[server]
			dev-db/postgresql:9.1[server]
			dev-db/postgresql:9.0[server]
		)
		dev-db/postgresql[threads]
		perl? ( dev-perl/DBD-Pg )
"

pkg_setup() {
	local PGSLOT="$(postgresql-config show)"
	if [[ ${PGSLOT//.} < 83 ]] ; then
		eerror "You must build ${CATEGORY}/${PN} against PostgreSQL 8.3 or higher."
		eerror "Set an appropriate slot with postgresql-config."
		die "postgresql-config not set to 8.3 or higher."
	fi

#	if [[ ${PGSLOT//.} > 90 ]] ; then
#		ewarn "You are building ${CATEGORY}/${PN} against a version of PostgreSQL greater than 9.0."
#		ewarn "This is neither supported here nor upstream."
#		ewarn "Any bugs you encounter should be reported upstream."
#	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.1.2-ldflags.patch"
}

src_configure() {
	local myconf
	use perl && myconf='--with-perltools'
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc HISTORY-1.1 INSTALL README SAMPLE TODO UPGRADING doc/howto/*.txt

	doman "${S}"/doc/adminguide/man{1,7}/*

	if use doc ; then
		cd "${S}"/doc
		dohtml -r *
	fi

	newinitd "${FILESDIR}"/slony1.init slony1
	newconfd "${FILESDIR}"/slony1.conf slony1
}
