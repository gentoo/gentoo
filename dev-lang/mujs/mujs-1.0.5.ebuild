# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="An embeddable Javascript interpreter in C."
HOMEPAGE="
	http://mujs.com/
	https://github.com/ccxvii/mujs/
"
SRC_URI="https://github.com/ccxvii/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}/${P}-flags.patch"
)

src_prepare() {
	default

	tc-export AR CC

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

	mv -v "${D}"/usr/$(get_libdir)/lib${PN}.so{,.${PV}} || die

	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so.${PV:0:1}
}
