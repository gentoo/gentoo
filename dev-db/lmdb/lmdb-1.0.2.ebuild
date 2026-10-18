# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs
inherit multilib multilib-minimal

MY_P="${PN^^}_${PV}"

DESCRIPTION="An ultra-fast, ultra-compact key-value embedded data store"
HOMEPAGE="https://symas.com/lmdb.php"
SRC_URI="https://git.openldap.org/openldap/openldap/-/archive/${MY_P}/openldap-${MY_P}.tar.gz"
S="${WORKDIR}/openldap-${MY_P}/libraries/liblmdb"

LICENSE="OPENLDAP"
# LMDB 1.x changes the on-disk format and cannot open 0.9 environments.
# It is deliberately NOT slotted alongside 0.9: one LMDB stack only.
# See bug #980734.
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

src_prepare() {
	default
	if [[ ${CHOST} == *-darwin* && ${CHOST#*-darwin} -lt 10 ]] ; then
		# posix_memalign isn't available before 10.6, but on OSX
		# malloc is always aligned for any addressable type
		sed -i -e '/(__APPLE__)/a#define HAVE_MEMALIGN 1\n#define memalign(X,Y) malloc(X)' mdb.c || die
	fi
	multilib_copy_sources
}

multilib_src_configure() {
	# Upstream's Makefile already passes -Wl,-soname,liblmdb.so.1 via
	# VERSION_OPT on ELF platforms; only darwin needs help.
	local version_opt
	if [[ ${CHOST} == *-darwin* ]] ; then
		version_opt="-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/liblmdb$(get_libname 1)"
		replace-flags -O[123456789] -O1
	fi
	sed -i -e "s!^CC.*!CC = $(tc-getCC)!" \
		-e "s!^CFLAGS.*!CFLAGS = \$(THREADS) ${CFLAGS}!" \
		-e "s!^LDFLAGS.*!LDFLAGS = \$(THREADS) ${LDFLAGS}!" \
		-e "s!^AR.*!AR = $(tc-getAR)!" \
		-e "s!^SOEXT.*!SOEXT = $(get_libname)!" \
		-e "/^prefix/s!/usr/local!${EPREFIX}/usr!" \
		-e "/^libdir/s!lib\$!$(get_libdir)!" \
		${version_opt:+-e "s!^VERSION_OPT.*!VERSION_OPT = ${version_opt}!"} \
		"Makefile" || die
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# Upstream installs liblmdb.so.1.0 plus liblmdb.so.1 and liblmdb.so
	# symlinks.  Static archive is not installed.
	rm "${ED}"/usr/$(get_libdir)/liblmdb.a || die

	# Upstream generates lmdb.pc by running the freshly built mdb_stat,
	# which does not work when cross-compiling, and does not install it.
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${FILESDIR}/lmdb.pc"
	sed -i -e "s!@PACKAGE_VERSION@!${PV}!" \
		-e "s!@prefix@!${EPREFIX}/usr!g" \
		-e "s!@libdir@!$(get_libdir)!" \
		"${ED}"/usr/$(get_libdir)/pkgconfig/lmdb.pc || die
}

multilib_src_install_all() {
	dodoc *.doc
}

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" -lt 1; then
			ewarn "LMDB ${PV} uses a new on-disk format and cannot open databases"
			ewarn "created by LMDB 0.9.  Existing environments must be exported"
			ewarn "with the 0.9 mdb_dump and re-imported with the ${PV} mdb_load."
			ewarn "Note that 'mdb_dump -a' does not include the main database;"
			ewarn "dump it separately.  See ${EROOT}/usr/share/doc/${PF}/upgrading.doc*"
			ewarn "and https://bugs.gentoo.org/980734"
			break
		fi
	done
}
