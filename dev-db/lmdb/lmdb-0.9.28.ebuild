# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic multilib-minimal toolchain-funcs

MY_P="${PN^^}_${PV}"

DESCRIPTION="An ultra-fast, ultra-compact key-value embedded data store"
HOMEPAGE="https://symas.com/lmdb/technical/"
SRC_URI="https://git.openldap.org/openldap/openldap/-/archive/${MY_P}/openldap-${MY_P}.tar.gz"

LICENSE="OPENLDAP"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/openldap-${MY_P}/libraries/liblmdb"

PATCHES=(
	"${FILESDIR}/${PN}-fix-cursor-delete.patch"
)

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
	local soname="-Wl,-soname,liblmdb$(get_libname 0)"
	if [[ ${CHOST} == *-darwin* ]] ; then
		soname="-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/liblmdb$(get_libname 0)"
		replace-flags -O[123456789] -O1
	fi
	sed -i -e "s!^CC.*!CC = $(tc-getCC)!" \
		-e "s!^CFLAGS.*!CFLAGS = ${CFLAGS}!" \
		-e "s!^AR.*!AR = $(tc-getAR)!" \
		-e "s!^SOEXT.*!SOEXT = $(get_libname)!" \
		-e "/^prefix/s!/usr/local!${EPREFIX}/usr!" \
		-e "/^libdir/s!lib\$!$(get_libdir)!" \
		-e "s!shared!shared ${soname}!" \
		"Makefile" || die

	if [[ ${CHOST} == *-solaris* ]] ; then
		# fdatasync lives in -lrt on Solaris 10
		[[ ${CHOST#*-solaris2.} -le 10 ]] && append-ldflags -lrt
	fi
}

multilib_src_compile() {
	emake LDLIBS+=" -pthread"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	mv "${ED}"/usr/$(get_libdir)/liblmdb$(get_libname) \
		"${ED}"/usr/$(get_libdir)/liblmdb$(get_libname 0) || die
	dosym liblmdb$(get_libname 0) /usr/$(get_libdir)/liblmdb$(get_libname)

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${FILESDIR}/lmdb.pc"
	sed -i -e "s!@PACKAGE_VERSION@!${PV}!" \
		-e "s!@prefix@!${EPREFIX}/usr!g" \
		-e "s!@libdir@!$(get_libdir)!" \
		"${ED}"/usr/$(get_libdir)/pkgconfig/lmdb.pc || die

	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/liblmdb.a || die
	fi
}
