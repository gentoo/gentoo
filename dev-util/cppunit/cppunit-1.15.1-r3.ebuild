# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal

DESCRIPTION="C++ port of the famous JUnit framework for unit testing"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/cppunit"

SRC_URI="https://dev-www.libreoffice.org/src/${P}.tar.gz"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

LICENSE="LGPL-2.1"
SLOT="0/1.15"
IUSE="doc examples"

BDEPEND="
	doc? (
		app-doc/doxygen[dot]
		media-gfx/graphviz
	)
"

DOCS=( AUTHORS BUGS NEWS README THANKS TODO ChangeLog doc/FAQ )

src_configure() {
	# Anything else than -O0 breaks on alpha
	use alpha && replace-flags "-O?" -O0

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-werror
		$(multilib_native_use_enable doc dot)
		$(multilib_native_use_enable doc doxygen)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	if use doc ; then
		mv "${ED}"/usr/share/${PN}/html "${ED}"/usr/share/doc/${PF} \
			|| die
		rm -r "${ED}"/usr/share/${PN} || die
	fi
	einstalldocs

	find "${ED}" -name '*.la' -delete || die

	if use examples ; then
		find examples -iname "*.o" -delete
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
