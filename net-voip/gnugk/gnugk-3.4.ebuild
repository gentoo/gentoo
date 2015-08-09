# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils versionator

MY_P1=${PN}-$(replace_version_separator 2 -)
MY_P2=${PN}-$(get_version_component_range 1-2)

DESCRIPTION="GNU H.323 gatekeeper"
HOMEPAGE="http://www.gnugk.org/"
SRC_URI="mirror://sourceforge/openh323gk/${MY_P1}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# dev-db/firebird isn't keyworded for ppc but firebird IUSE is masked for ppc
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc firebird lua mysql odbc postgres radius snmp sqlite ssh linguas_en linguas_es linguas_fr"
REQUIRED_USE="doc? (
	|| ( linguas_en linguas_es linguas_fr )
	)
"

RDEPEND="net-libs/ptlib:=
	net-libs/h323plus:=
	dev-libs/openssl
	firebird? ( dev-db/firebird )
	lua? ( dev-lang/lua )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql )
	snmp? ( net-analyzer/net-snmp )
	ssh? ( net-libs/libssh )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	doc? ( app-text/linuxdoc-tools )"

S=${WORKDIR}/${MY_P2}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.4-ptrace.patch
	epatch "${FILESDIR}"/${PN}-3.2.2-h323plus-buildopts.patch
	epatch "${FILESDIR}"/${PN}-3.2.2-lua.cxx-toolkit_h.patch
}

# TODO: investigate possible ebuild conversion to use cmake
src_configure() {
	# --with-large-fdset=4096 is added because of bug #128102
	# and it is recommended in the online manual
	econf \
		$(use_enable firebird) \
		$(use_enable lua) \
		$(use_enable mysql) \
		$(use_enable postgres pgsql) \
		$(use_enable odbc unixodbc) \
		$(use_enable radius) \
		$(use_enable snmp netsnmp) \
		$(use_enable sqlite) \
		$(use_enable ssh libssh) \
		--with-large-fdset=4096
}

src_compile() {
	# PASN_NOPRINT should be set for -debug but it's buggy
	# better to prevent issues and keep default settings
	# `make debugdepend debugshared` and `make debug` failed (so no debug)
	# `make optdepend optnoshared` also failed (so no static)

	# splitting emake calls fixes parallel build issue
	emake optdepend
	emake \
		PT_LIBDIR="$(ptlib-config --libdir)" \
		OH323_LIBDIR="${EPREFIX}"/usr/lib \
		optshared
	# build tool addpasswd
	emake -C addpasswd PTLIBDIR="$(ptlib-config --ptlibdir)"

	if use doc; then
		cd docs/manual

		if use linguas_en; then
			emake html
		fi

		if use linguas_es; then
			emake html-es
		fi

		if use linguas_fr; then
			emake html-fr
		fi
		cd ../..
	fi
}

src_install() {
	dosbin obj_*_*_*/${PN}
	dosbin addpasswd/obj_*_*_*/addpasswd

	dodir /etc/${PN}
	insinto /etc/${PN}
	doins etc/*

	dodoc changes.txt readme.txt
	dodoc docs/*.txt docs/*.pdf

	if use doc; then
		if use linguas_en; then
			dohtml docs/manual/manual*.html
		fi
		if use linguas_fr; then
			dohtml docs/manual/fr/manual-fr*.html
		fi
		if use linguas_es; then
			dohtml docs/manual/es/manual-es*.html
		fi
	fi

	doman docs/${PN}.1 docs/addpasswd.1

	newinitd "${FILESDIR}"/${PN}.rc6 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
