# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/cvm/cvm-0.96.ebuild,v 1.5 2014/12/28 16:29:23 titanofold Exp $

EAPI=2

inherit toolchain-funcs eutils

DESCRIPTION="Credential Validation Modules by Bruce Guenter"
HOMEPAGE="http://untroubled.org/cvm/"
SRC_URI="${HOMEPAGE}archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="mysql postgres test vpopmail"

RDEPEND="dev-db/cdb"
DEPEND="${RDEPEND}
		>=dev-libs/bglibs-1.041
		mysql? ( virtual/mysql )
		postgres? ( dev-db/postgresql[server] )
		vpopmail? ( net-mail/vpopmail )
		test? ( app-editors/vim )"
# some of the testcases use ex/vi/xxd

MAKEOPTS="${MAKEOPTS} -j1" #310843

src_unpack() {
	unpack ${A}
	# disable this test, as it breaks under Portage
	# and there is no easy fix
	sed -i.orig \
		-e '/qmail-lookup-nodomain/,/^END_OF_TEST_RESULTS/d' \
		"${S}"/tests.sh || die "sed failed"
	# Fix the vpopmail build
	sed -i.orig \
		-e '/.\/ltload cvm-vchkpw/s,-lmysqlclient,,g' \
		-e '/.\/ltload cvm-vchkpw/s,-L/usr/local/vpopmail/lib,,g' \
		-e '/.\/ltload cvm-vchkpw/s,-L/var/vpopmail/lib,,g' \
		-e '/.\/ltload cvm-vchkpw/s,-L/usr/local/lib/mysql,,g' \
		-e '/.\/ltload cvm-vchkpw/s,\.la,.la `cat /var/vpopmail/etc/lib_deps`,g' \
		"${S}"/Makefile \
		|| die "Failed to fix vpopmail linking parts of Makefile"
	sed -i.orig \
		-e '/.\/compile cvm-vchkpw/s,$, `cat /var/vpopmail/etc/inc_deps`,g' \
		"${S}"/Makefile \
		|| die "Failed to fix vpopmail compiling parts of Makefile"
}

src_compile() {
	echo "/usr/include/bglibs" > conf-bgincs
	echo "/usr/lib/bglibs" > conf-bglibs
	echo "/usr/include" > conf-include
	echo "/usr/lib" > conf-lib
	echo "/usr/bin" > conf-bin
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS} -lcrypt" > conf-ld
	emake || die

	if use mysql; then
		einfo "Building MySQL support"
		emake mysql || die "making mysql support failed"
	fi

	if use postgres; then
		einfo "Building Postgresql support"
		emake pgsql || die "making postgres support failed"
	fi

	if use vpopmail; then
		einfo "Building vpopmail support"
		emake cvm-vchkpw || die "making vpopmail support failed"
	fi
}

src_install() {
	# Upstreams installer is incredibly broken
	dolib .libs/*.a .libs/*.so.*
	for i in a so ; do
		dosym libcvm-v2client.${i} /usr/$(get_libdir)/libcvm-client.${i}
	done

	for i in {bench,test}client chain checkpassword pwfile qmail unix \
			vmailmgr{,-local,-udp} v1{benchclient,checkpassword,testclient} \
			; do
			dobin .libs/cvm-${i}
	done
	use mysql && dobin .libs/cvm-mysql{,-local,-udp}
	use postgres && dobin .libs/cvm-pgsql{,-local,-udp}
	use vpopmail && dobin .libs/cvm-vchkpw

	insinto /usr/include/cvm
	doins {credentials,errors,facts,module,protocol,sasl,v1client,v2client}.h
	dosym v1client.h /usr/include/cvm/client.h
	dosym cvm/sasl.h /usr/include/cvm-sasl.h

	dodoc ANNOUNCEMENT NEWS{,.sql,.vmailmgr}
	dodoc README{,.vchkpw,.vmailmgr}
	dodoc TODO VERSION ChangeLog*
	dohtml *.html
}

src_test() {
	sh tests.sh || die "Testing Failed"
}
