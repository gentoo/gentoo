# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic java-pkg-opt-2

PATCHSET_VER="11"

DESCRIPTION="YAP is a high-performance Prolog compiler"
HOMEPAGE="http://www.dcc.fc.up.pt/~vsc/Yap/"
SRC_URI="http://www.dcc.fc.up.pt/~vsc/Yap/${P}.tar.gz
	mirror://gentoo/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="Artistic LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="R debug doc examples gmp java mpi mysql odbc readline static threads"

RDEPEND="sys-libs/zlib
	gmp? ( dev-libs/gmp:0 )
	java? ( >=virtual/jdk-1.4:= )
	mpi? ( virtual/mpi )
	mysql? ( dev-db/mysql-connector-c:0= )
	odbc? ( dev-db/unixODBC )
	readline? ( sys-libs/readline:= sys-libs/ncurses:= )
	R? ( dev-lang/R )"

DEPEND="${RDEPEND}
	doc? ( app-text/texi2html )"

PATCHES=( "${WORKDIR}"/${PV} )

src_prepare() {
	default
	rm -rf "${S}"/yap || die "failed to remove yap xcode project"

	# Fix QA error on doc location
	local mFile
	for mFile in Makefile.in packages/Dialect.defs.in \
			$(find packages -name Makefile.in) ; do
		sed -i -e "s~doc/Yap~doc/${PF}~" "${mFile}" || die
	done
}

src_configure() {
	append-flags -fno-strict-aliasing

	local myddas_conf
	if use mysql || use odbc; then
		myddas_conf="--enable-myddas"
	else
		myddas_conf="--disable-myddas"
	fi
	if use mysql; then
		myddas_conf="$myddas_conf yap_with_mysql=yes"
	fi
	if use odbc; then
		myddas_conf="$myddas_conf yap_with_odbc=yes"
	fi

	econf \
		--libdir=/usr/$(get_libdir) \
		--disable-prism \
		--disable-gecode \
		$(use_enable !static dynamic-loading) \
		$(use_enable threads) \
		$(use_enable threads pthread-locking) \
		$(use_enable debug debug-yap) \
		$(use_enable debug low-level-tracer) \
		$(use_with gmp) \
		$(use_with readline) \
		$(use_with mpi) \
		$(use_with mpi mpe) \
		$(use_with java) \
		$(use_with R) \
		${myddas_conf}
}

src_compile() {
	default

	if use doc ; then
		emake html
	fi
}

src_test() {
	# libtai package contains check.c which confuses the default
	# src_test() function
	true
}

src_install() {
	default

	dodoc changes*.html README

	if use doc ; then
		dodoc yap.html
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples/chr
		doins packages/chr/Examples/*
		insinto /usr/share/doc/${PF}/examples/clib
		doins packages/clib/demo/*
		insinto /usr/share/doc/${PF}/examples/http
		doins -r packages/http/examples/*
		insinto /usr/share/doc/${PF}/examples/plunit
		doins packages/plunit/examples/*
		if use java ; then
			insinto /usr/share/doc/${PF}/examples/jpl/prolog
			doins packages/jpl/examples/prolog/*
			insinto /usr/share/doc/${PF}/examples/jpl/java
			doins packages/jpl/examples/java/README
			doins -r packages/jpl/examples/java/*/*.{java,pl}
		fi
		if use mpi ; then
			insinto /usr/share/doc/${PF}/examples/mpi
			doins library/mpi/examples/*.pl
		fi
	fi
}
