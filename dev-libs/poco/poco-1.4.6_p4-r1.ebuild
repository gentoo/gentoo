# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs flag-o-matic multilib versionator

MY_P="${P/_}"
MY_DOCP="${PN}-$(get_version_component_range 1-3)-all-doc"

DESCRIPTION="C++ class libraries to simplify the development of network-centric, portable applications"
HOMEPAGE="http://pocoproject.org/"
SRC_URI="http://pocoproject.org/releases/poco-$(get_version_component_range 1-3)/${MY_P}-all.tar.bz2
	doc? ( mirror://sourceforge/poco/${MY_DOCP}.zip )"
LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc examples iodbc libressl mysql odbc sqlite ssl test"

DEPEND=">=dev-libs/libpcre-8.13
	dev-libs/expat
	sys-libs/zlib
	mysql? ( virtual/mysql )
	odbc? ( iodbc? ( dev-db/libiodbc )
		!iodbc? ( dev-db/unixODBC ) )
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	sqlite? ( dev-db/sqlite:3 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}-all"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-gentoo.patch \
		"${FILESDIR}"/poco-1.4.4-patch-for-libpcre-8.32.patch
}

src_configure() {
	targets="libexecs"
	odbc="unixodbc"

	if use ssl; then
		targets="${targets} NetSSL_OpenSSL-libexec Crypto-libexec"
		echo NetSSL_OpenSSL >> components
		echo Crypto >> components
	fi
	if use odbc; then
		targets="${targets} Data/ODBC-libexec"
		echo Data/ODBC >> components
		if use iodbc; then
			append-flags "-I/usr/include/iodbc"
			odbc="iodbc"
		fi
	fi
	if use sqlite; then
		targets="${targets} Data/SQLite-libexec"
		echo Data/SQLite >> components
	fi
	if use mysql; then
		targets="${targets} Data/MySQL-libexec"
		echo Data/MySQL >> components
	fi

	if use test; then
		targets="${targets} cppunit tests"
		echo CppUnit >> components
		use ssl && targets="${targets} NetSSL_OpenSSL-tests Crypto-tests"
		use odbc && targets="${targets} Data/ODBC-tests"
		use sqlite && targets="${targets} Data/SQLite-tests"
		use mysql && targets="${targets} Data/MySQL-tests"
	fi

	local myconf
	use test || myconf="--no-tests"
	# not autoconf
	./configure \
		--no-samples ${myconf} \
		--prefix=/usr \
		--unbundled \
		|| die "configure failed"

	sed -i \
		-e 's|-O2||g' \
		-e "s|CC      = .*|CC      = $(tc-getCC)|" \
		-e "s|CXX     = .*|CXX     = $(tc-getCXX)|" \
		-e "s|RANLIB  = .*|RANLIB  = $(tc-getRANLIB)|" \
		-e "s|LIB     = ar|LIB     = $(tc-getAR)|" \
		-e "s|STRIP   = .*|STRIP   = /bin/true|" \
		-e "s|CFLAGS          = |CFLAGS          = ${CFLAGS}|" \
		-e "s|CXXFLAGS        = |CXXFLAGS        = ${CXXFLAGS} |" \
		-e "s|LINKFLAGS       =|LINKFLAGS       = ${LDFLAGS} |" \
		-e "s|SHAREDOPT_LINK  = -Wl,-rpath,\$(LIBPATH)|SHAREDOPT_LINK  =|" \
		build/config/Linux build/config/FreeBSD || die "sed failed"
	sed -i -e "s|SHLIBFLAGS)|SHLIBFLAGS) ${LDFLAGS}|" build/rules/lib || die
}

src_compile() {
	emake POCO_PREFIX=/usr GENTOO_ODBC="${odbc}" LIBDIR="$(get_libdir)" ${targets} || die "emake failed"
}

src_install() {
	emake POCO_PREFIX=/usr LIBDIR="$(get_libdir)" DESTDIR="${D}" install || die "emake install failed"

	dodoc CHANGELOG CONTRIBUTORS NEWS README

	use doc && dohtml -r "${WORKDIR}/${MY_DOCP}"/*

	if use examples ; then
		for d in Net XML Data Util NetSSL_OpenSSL Foundation ; do
			insinto /usr/share/doc/${PF}/examples/${d}
			doins -r ${d}/samples
		done
		find "${D}/usr/share/doc/${PF}/examples" \
			-iname "*.sln" -or -iname "*.vcproj" -or \
			-iname "*.vmsbuild" -or -iname "*.properties" \
			| xargs rm
	fi
}
