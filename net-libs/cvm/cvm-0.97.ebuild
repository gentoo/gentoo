# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Credential Validation Modules by Bruce Guenter"
HOMEPAGE="http://untroubled.org/cvm/"
SRC_URI="http://untroubled.org/cvm/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE="mysql postgres test vpopmail"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/cdb:=
	>=dev-libs/bglibs-2.04:0="
DEPEND="${RDEPEND}
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql[server] )
	vpopmail? ( net-mail/vpopmail )
	test? (
		app-editors/vim
		dev-db/sqlite
	)"
# some of the testcases use
# - ex/vi/xxd
# - cdbmake
# - sqlite

PATCHES=( "${FILESDIR}"/${PN}-0.96-fix-test-padding.patch )

src_prepare() {
	default
	# disable this test, as it breaks under Portage
	# and there is no easy fix
	sed -i.orig \
		-e '/qmail-lookup-nodomain/,/^END_OF_TEST_RESULTS/d' \
		tests.sh || die "sed failed"
	# Fix the vpopmail build
	sed -i.orig \
		-e '/.\/ltload cvm-vchkpw/s,-lmysqlclient,,g' \
		-e '/.\/ltload cvm-vchkpw/s,-L/usr/local/vpopmail/lib,,g' \
		-e '/.\/ltload cvm-vchkpw/s,-L/var/vpopmail/lib,,g' \
		-e '/.\/ltload cvm-vchkpw/s,-L/usr/local/lib/mysql,,g' \
		-e '/.\/ltload cvm-vchkpw/s,\.la,.la `cat /var/vpopmail/etc/lib_deps`,g' \
		Makefile \
		|| die "Failed to fix vpopmail linking parts of Makefile"
	sed -i.orig \
		-e '/.\/compile cvm-vchkpw/s,$, `cat /var/vpopmail/etc/inc_deps`,g' \
		Makefile \
		|| die "Failed to fix vpopmail compiling parts of Makefile"
	sed -i '/\-rpath/s|conf\-lib|conf\-rpath|' Makefile || die
}

src_configure() {
	echo "${ED}/usr/include" > conf-include || die
	echo "${ED}/usr/$(get_libdir)" > conf-lib || die
	echo "${ED}/usr/bin" > conf-bin || die
	echo "${EPREFIX}/usr/$(get_libdir)" > conf-rpath || die
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS} -L${EPREFIX}/usr/$(get_libdir)/bglibs -lcrypt" > conf-ld || die
}

src_compile() {
	emake -j1

	if use mysql; then
		einfo "Building MySQL support"
		emake mysql
	fi

	if use postgres; then
		einfo "Building Postgresql support"
		emake pgsql
	fi

	if use vpopmail; then
		einfo "Building vpopmail support"
		emake cvm-vchkpw
	fi
}

src_test() {
	# bug 624384
	# the test suite tests stuff that isn't potentially enabled
	emake -j1 sqlite
	sh tests.sh || die "Testing Failed"
}

src_install() {
	# Upstreams installer is incredibly broken
	dolib.a .libs/*.a
	dolib.so .libs/*.so*

	local i
	for i in a so; do
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
	docinto html
	dodoc *.html
}
