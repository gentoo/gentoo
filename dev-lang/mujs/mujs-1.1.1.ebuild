# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="An embeddable JavaScript interpreter in C"
HOMEPAGE="https://mujs.com/ https://github.com/ccxvii/mujs"
SRC_URI="https://mujs.com/downloads/${P}.tar.xz"
#SRC_URI=" https://github.com/ccxvii/mujs/archive/${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="ISC"
# subslot matches SONAME
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos"

RDEPEND="sys-libs/readline:0="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.1-flags.patch
)

src_prepare() {
	default

	tc-export AR CC

	append-cflags -fPIC

	# library's ABI (and API) changes in ~each release:
	# diff 'usr/includemujs.h' across releases to validate
	if [[ ${CHOST} == *-darwin* ]] ; then
		append-cflags -Wl,-install_name,"${EPREFIX}"/usr/$(get_libdir)/lib${PN}.${PV}.dylib
	else
		append-cflags -Wl,-soname=lib${PN}.so.${PV}
	fi
}

src_compile() {
	emake \
		VERSION=${PF} \
		XCFLAGS="${CFLAGS}" \
		XCPPFLAGS="${CPPFLAGS}" \
		prefix=/usr \
		shell shared
}

src_install() {
	local myemakeargs=(
		DESTDIR="${ED}"
		VERSION=${PF}
		libdir="/usr/$(get_libdir)"
		prefix=/usr
	)

	emake "${myemakeargs[@]}" install-shared

	# TODO: Tidy up this logic, improve readability
	if [[ ${CHOST} == *-darwin* ]] ; then
		mv -v "${ED}"/usr/$(get_libdir)/lib${PN}.so "${ED}"/usr/$(get_libdir)/lib${PN}.${PV}.dylib || die
		dosym lib${PN}.${PV}.dylib /usr/$(get_libdir)/lib${PN}.dylib
		dosym lib${PN}.${PV}.dylib /usr/$(get_libdir)/lib${PN}.${PV:0:1}.dylib
	else
		mv -v "${ED}"/usr/$(get_libdir)/lib${PN}.so{,.${PV}} || die
		dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so
		dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so.${PV:0:1}
	fi
}
