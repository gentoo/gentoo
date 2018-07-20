# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P="XSB${PV//./}"

PATCHSET_VER="4"

inherit eutils autotools java-pkg-opt-2

DESCRIPTION="XSB is a logic programming and deductive database system"
HOMEPAGE="http://xsb.sourceforge.net"
SRC_URI="http://xsb.sourceforge.net/downloads/${MY_P}.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="curl debug iodbc java mysql odbc pcre threads xml"

RDEPEND="curl? ( net-misc/curl )
	iodbc? ( dev-db/libiodbc )
	java? ( >=virtual/jdk-1.4:= )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	pcre? ( dev-libs/libpcre )
	xml? ( dev-libs/libxml2 )"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/XSB

src_prepare() {
	EPATCH_FORCE=yes
	EPATCH_SUFFIX=patch
	epatch "${WORKDIR}"/${PV}

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

	emake || die "emake failed"

	# All XSB Packages are compiled using a single Prolog engine.
	# Consequently they must all be compiled using a single make job.

	cd "${S}"/packages
	rm -f *.xwam
	emake -j1 || die "emake packages failed"

	if use curl ; then
		emake -j1 curl || die "emake curl package failed"
		emake -j1 sgml || die "emake sgml package failed"
		if use xml ; then
			emake -j1 xpath || die "emake xpath package failed"
		fi
	fi

	if use mysql ; then
		emake -j1 mysql || die "emake mysql package failed"
	fi

	if use odbc ; then
		emake -j1 odbc || die "emake odbc package failed"
	fi

	if use pcre ; then
		emake -j1 pcre || die "emake pcre package failed"
	fi
}

src_install() {
	cd "${S}"/build
	emake DESTDIR="${D}" install || die "make install failed"

	local XSB_INSTALL_DIR=/usr/$(get_libdir)/xsb-${PV}
	dosym ${XSB_INSTALL_DIR}/bin/xsb /usr/bin/xsb || die

	cd "${S}"/packages
	local PACKAGES=${XSB_INSTALL_DIR}/packages
	insinto ${PACKAGES}
	doins *.xwam || die

	insinto ${PACKAGES}/chr
	doins chr/*.xwam || die

	insinto ${PACKAGES}/clpqr
	doins clpqr/*.xwam || die

	insinto ${PACKAGES}/gap
	doins gap/*.xwam || die

	insinto ${PACKAGES}/justify
	doins justify/*.xwam || die
	doins justify/*.H || die

	insinto ${PACKAGES}/regmatch
	doins regmatch/*.xwam || die
	insinto ${PACKAGES}/regmatch/cc
	doins regmatch/cc/*.H || die

	insinto ${PACKAGES}/slx
	doins slx/*.xwam || die

	insinto ${PACKAGES}/wildmatch
	doins wildmatch/*.xwam || die
	insinto ${PACKAGES}/wildmatch/cc
	doins wildmatch/cc/*.H || die

	if use curl ; then
		insinto ${PACKAGES}/curl
		doins curl/*.xwam || die
		insinto ${PACKAGES}/curl/cc
		doins curl/cc/*.H || die
		insinto ${PACKAGES}/sgml
		doins sgml/*.xwam || die
		insinto ${PACKAGES}/sgml/cc
		doins sgml/cc/*.H || die
		insinto ${PACKAGES}/sgml/cc/dtd
		doins sgml/cc/dtd/* || die
		if use xml ; then
			insinto ${PACKAGES}/xpath
			doins xpath/*xwam || die
			insinto ${PACKAGES}/xpath/cc
			doins xpath/cc/*.H || die
		fi
	fi

	if use mysql || use odbc ; then
		insinto ${PACKAGES}/dbdrivers
		doins dbdrivers/*.xwam || die
		doins dbdrivers/*.H || die
		insinto ${PACKAGES}/dbdrivers/cc
		doins dbdrivers/cc/*.H || die
		if use mysql ; then
			insinto ${PACKAGES}/dbdrivers/mysql
			doins dbdrivers/mysql/*.xwam || die
			insinto ${PACKAGES}/dbdrivers/mysql/cc
			doins dbdrivers/mysql/cc/*.H || die
		fi
		if use odbc ; then
			insinto ${PACKAGES}/dbdrivers/odbc
			doins dbdrivers/odbc/*.xwam || die
			insinto ${PACKAGES}/dbdrivers/odbc/cc
			doins dbdrivers/odbc/cc/*.H || die
		fi
	fi

	if use pcre ; then
		insinto ${PACKAGES}/pcre
		doins pcre/*.xwam || die
		insinto ${PACKAGES}/pcre/cc
		doins pcre/cc/*.H || die
	fi

	cd "${S}"
	dodoc FAQ README || die
}
