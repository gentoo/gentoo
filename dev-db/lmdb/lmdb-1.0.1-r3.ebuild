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
# LMDB 1.0 changes the on-disk format with no in-place upgrade path.
# In Slot 1 only the versioned shared library lives at its normal path.
# Headers, the dev symlink, pkg-config and the mdb_* tools all move to
# versioned locations so that slot 0 (0.9.x) keeps every canonical path and
# both slots co-install.
#
# Migration requires 0.9 mdb_dump and 1.0 mdb1_load at the same time.
#
# No static-libs: Get rid of static libs while slotting.
SLOT="1/${PV}"
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
		-e "s!^CFLAGS.*!CFLAGS = ${CFLAGS}!" \
		-e "s!^AR.*!AR = $(tc-getAR)!" \
		-e "s!^SOEXT.*!SOEXT = $(get_libname)!" \
		-e "/^prefix/s!/usr/local!${EPREFIX}/usr!" \
		-e "/^libdir/s!lib\$!$(get_libdir)!" \
		${version_opt:+-e "s!^VERSION_OPT.*!VERSION_OPT = ${version_opt}!"} \
		"Makefile" || die
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	local libdir=/usr/$(get_libdir)

	# Dev symlink out of slot 0's way.
	# Upstream installs liblmdb.so -> liblmdb.so.1.0 in libdir.
	rm "${ED}${libdir}"/liblmdb$(get_libname) || die
	dosym ../liblmdb$(get_libname 1.0) ${libdir}/lmdb1/liblmdb$(get_libname)
	rm "${ED}${libdir}"/liblmdb.a || die

	# Header
	dodir /usr/include/lmdb1
	mv "${ED}"/usr/include/lmdb.h "${ED}"/usr/include/lmdb1/ || die

	# pkg-config; upstream does not install one.
	insinto ${libdir}/pkgconfig
	doins "${FILESDIR}/lmdb1.pc"
	sed -i -e "s!@PACKAGE_VERSION@!${PV}!" \
		-e "s!@prefix@!${EPREFIX}/usr!g" \
		-e "s!@libdir@!$(get_libdir)!" \
		"${ED}${libdir}"/pkgconfig/lmdb1.pc || die

	# Tools and man pages: mdb_* -> mdb1_*
	local f
	for f in "${ED}"/usr/bin/mdb_* "${ED}"/usr/share/man/man1/mdb_* ; do
		mv "${f}" "${f%/*}/mdb1_${f##*/mdb_}" || die
	done
}

multilib_src_install_all() {
	dodoc *.doc
}
