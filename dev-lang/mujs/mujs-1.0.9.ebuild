# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="An embeddable JavaScript interpreter in C"
HOMEPAGE="https://mujs.com/ https://github.com/ccxvii/mujs"
SRC_URI="https://github.com/ccxvii/mujs/archive/${PV}.tar.gz -> ${P}.tar.gz"
# Not available right now.
#SRC_URI="https://mujs.com/downloads/${P}.tar.xz"

LICENSE="ISC"
# subslot matches SONAME
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 s390 sparc x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="static-libs"

RDEPEND="sys-libs/readline:0="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.5-flags.patch"
)

src_prepare() {
	default

	tc-export AR CC

	# library's ABI (and API) changes in ~each release:
	# diff 'usr/includemujs.h' across releases to validate
	append-cflags -fPIC -Wl,-soname=lib${PN}.so.${PV}
}

src_compile() {
	emake VERSION=${PV} prefix=/usr shared
}

src_install() {
	local myeconfargs=(
		DESTDIR="${ED}"
		install-shared
		libdir="/usr/$(get_libdir)"
		prefix="/usr"
		VERSION="${PV}"
		$(usex static-libs install-static '')
	)

	emake "${myeconfargs[@]}"

	mv -v "${ED}"/usr/$(get_libdir)/lib${PN}.so{,.${PV}} || die

	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so.${PV:0:1}
}
