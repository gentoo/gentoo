# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="An embeddable JavaScript interpreter written in C"
HOMEPAGE="https://mujs.com/ https://github.com/ccxvii/mujs"
SRC_URI="https://mujs.com/downloads/${P}.tar.gz"

LICENSE="ISC"
# The subslot matches the SONAME
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos"

RDEPEND="sys-libs/readline:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-flags.patch
)

src_prepare() {
	default

	tc-export AR CC

	append-cflags -fPIC

	# The library's ABI (and API) might change in new releases
	# Diff 'usr/include/mujs.h' across releases to validate
	if [[ ${CHOST} == *-darwin* ]] ; then
		append-cflags -Wl,-install_name,"${EPREFIX}"/usr/$(get_libdir)/lib${PN}.${PV}.dylib
	else
		append-cflags -Wl,-soname=lib${PN}.so.${PV}
	fi
}

src_compile() {
	# We need to use ${PV} for the pkgconfig file, see: #784461
	emake \
		VERSION=${PV} \
		XCFLAGS="${CFLAGS}" \
		XCPPFLAGS="${CPPFLAGS}" \
		prefix=/usr \
		shell shared
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		VERSION=${PV} \
		libdir="/usr/$(get_libdir)" \
		prefix=/usr \
		install-shared

	mv -v "${ED}"/usr/$(get_libdir)/lib${PN}$(get_libname) "${ED}"/usr/$(get_libdir)/lib${PN}$(get_libname ${PV}) || die "Failed adding version suffix to mujs shared library"
	dosym lib${PN}$(get_libname ${PV}) /usr/$(get_libdir)/lib${PN}$(get_libname)
	dosym lib${PN}$(get_libname ${PV}) /usr/$(get_libdir)/lib${PN}$(get_libname ${PV:0:1})
}
