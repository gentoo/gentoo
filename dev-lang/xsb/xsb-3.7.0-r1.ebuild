# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="XSB${PV//./}"

PATCHSET_VER="3"

inherit autotools java-pkg-opt-2

DESCRIPTION="XSB is a logic programming and deductive database system"
HOMEPAGE="http://xsb.sourceforge.net"
SRC_URI="http://xsb.sourceforge.net/downloads/${MY_P}.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl debug iodbc java mysql odbc pcre threads xml"

RDEPEND="curl? ( net-misc/curl )
	iodbc? ( dev-db/libiodbc )
	java? ( >=virtual/jdk-1.4:= )
	mysql? ( dev-db/mysql-connector-c:0= )
	odbc? ( dev-db/unixODBC )
	pcre? ( dev-libs/libpcre )
	xml? ( dev-libs/libxml2 )"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/XSB

PATCHES=( "${WORKDIR}/${PV}" )

src_prepare() {
	default
	cd "${S}"/build
	eautoconf
}

src_configure() {
	cd "${S}"/build

	econf \
		--prefix=/usr/$(get_libdir) \
		--disable-optimization \
		--without-smodels \
		$(use_with odbc) \
		$(use_with iodbc) \
		$(use_enable threads mt) \
		$(use_enable debug)

	if use curl ; then
		cd "${S}"/packages/curl
		econf
	fi

	if use mysql ; then
		cd "${S}"/packages/dbdrivers/mysql
		econf
	fi

	if use odbc ; then
		cd "${S}"/packages/dbdrivers/odbc
		econf
	fi

	if use pcre ; then
		cd "${S}"/packages/pcre
		econf
	fi

	if use xml ; then
		cd "${S}"/packages/xpath
		econf
	fi
}

src_compile() {
	cd "${S}"/build

	default

	# All XSB Packages are compiled using a single Prolog engine.
	# Consequently they must all be compiled using a single make job.

	cd "${S}"/packages
	rm -f *.xwam
	emake -j1

	if use curl ; then
		emake -j1 curl
		emake -j1 sgml
		if use xml ; then
			emake -j1 xpath
		fi
	fi

	if use mysql ; then
		emake -j1 mysql
	fi

	if use odbc ; then
		emake -j1 odbc
	fi

	if use pcre ; then
		emake -j1 pcre
	fi
}

src_install() {
	cd "${S}"/build
	default

	local XSB_INSTALL_DIR=/usr/$(get_libdir)/xsb-${PV}
	dosym ${XSB_INSTALL_DIR}/bin/xsb /usr/bin/xsb

	cd "${S}"/packages
	local PACKAGES=${XSB_INSTALL_DIR}/packages
	insinto ${PACKAGES}
	doins *.xwam

	insinto ${PACKAGES}/chr
	doins chr/*.xwam

	insinto ${PACKAGES}/clpqr
	doins clpqr/*.xwam

	insinto ${PACKAGES}/gap
	doins gap/*.xwam

	insinto ${PACKAGES}/justify
	doins justify/*.xwam
	doins justify/*.H

	insinto ${PACKAGES}/regmatch
	doins regmatch/*.xwam
	insinto ${PACKAGES}/regmatch/cc
	doins regmatch/cc/*.H

	insinto ${PACKAGES}/slx
	doins slx/*.xwam

	insinto ${PACKAGES}/wildmatch
	doins wildmatch/*.xwam
	insinto ${PACKAGES}/wildmatch/cc
	doins wildmatch/cc/*.H

	if use curl ; then
		insinto ${PACKAGES}/curl
		doins curl/*.xwam
		insinto ${PACKAGES}/curl/cc
		doins curl/cc/*.H
		insinto ${PACKAGES}/sgml
		doins sgml/*.xwam
		insinto ${PACKAGES}/sgml/cc
		doins sgml/cc/*.H
		insinto ${PACKAGES}/sgml/cc/dtd
		doins sgml/cc/dtd/*
		if use xml ; then
			insinto ${PACKAGES}/xpath
			doins xpath/*xwam
			insinto ${PACKAGES}/xpath/cc
			doins xpath/cc/*.H
		fi
	fi

	if use mysql || use odbc ; then
		insinto ${PACKAGES}/dbdrivers
		doins dbdrivers/*.xwam
		doins dbdrivers/*.H
		insinto ${PACKAGES}/dbdrivers/cc
		doins dbdrivers/cc/*.H
		if use mysql ; then
			insinto ${PACKAGES}/dbdrivers/mysql
			doins dbdrivers/mysql/*.xwam
			insinto ${PACKAGES}/dbdrivers/mysql/cc
			doins dbdrivers/mysql/cc/*.H
		fi
		if use odbc ; then
			insinto ${PACKAGES}/dbdrivers/odbc
			doins dbdrivers/odbc/*.xwam
			insinto ${PACKAGES}/dbdrivers/odbc/cc
			doins dbdrivers/odbc/cc/*.H
		fi
	fi

	if use pcre ; then
		insinto ${PACKAGES}/pcre
		doins pcre/*.xwam
		insinto ${PACKAGES}/pcre/cc
		doins pcre/cc/*.H
	fi

	cd "${S}"
	dodoc FAQ README
}
