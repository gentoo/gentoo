# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

DESCRIPTION="A set of frameworks forming a complete Web application server environment"
HOMEPAGE="https://www.sogo.nu/"
SRC_URI="https://github.com/inverse-inc/sope/archive/SOPE-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PN^^}-${PV}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnutls ldap mysql postgres +ssl +xml"

RDEPEND="
	virtual/zlib:=
	ldap? ( net-nds/openldap:= )
	gnutls? ( net-libs/gnutls:= )
	!gnutls? (
		dev-libs/openssl:0=
	)
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:= )
	xml? ( dev-libs/libxml2:2= )
"
DEPEND="${RDEPEND}"

src_configure() {
	egnustep_env

	local myconf=(
		--prefix="${EPREFIX}"
		--disable-strip
		$(use_enable debug)
		$(use_enable ldap openldap)
		$(use_enable mysql)
		$(use_enable postgres postgresql)
		$(use_enable xml)
		--with-gnustep
	)

	if use ssl ; then
		if use gnutls ; then
			myconf+=( --with-ssl=gnutls )
		else
			myconf+=( --with-ssl=ssl )
		fi
	else
		myconf+=( --with-ssl=none )
	fi

	# Non-standard configure script
	./configure "${myconf[@]}" || die "configure failed"
}
