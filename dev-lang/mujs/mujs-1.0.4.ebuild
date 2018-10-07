# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="lightweight Javascript interpreter"
HOMEPAGE="http://mujs.com/"
SRC_URI="https://mujs.com/downloads/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.4-gentoo.patch
)

src_prepare() {
	default
	append-cflags -fPIC -Wl,-soname=lib${PN}.so.${PV}
	tc-export CC
}

src_compile() {
	emake VERSION=${PV} prefix=/usr shared
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		VERSION=${PV} \
		prefix=/usr \
		libdir="/usr/$(get_libdir)" \
		install-shared \
		$(usex static-libs install-static '')

	mv -v "${D}"/usr/$(get_libdir)/lib${PN}.so{,.${PV}} || die
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so || die
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so.${PV:0:1} || die
}
