# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://anongit.freedesktop.org/git/libreoffice/cppunit.git"
[[ ${PV} = 9999 ]] && inherit git-r3 autotools
inherit flag-o-matic multilib-minimal

DESCRIPTION="C++ port of the famous JUnit framework for unit testing"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/cppunit"
[[ ${PV} = 9999 ]] || SRC_URI="https://dev-www.libreoffice.org/src/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} = 9999 ]] || \
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen[dot]
		media-gfx/graphviz
	)
"

DOCS=( AUTHORS BUGS NEWS README THANKS TODO doc/FAQ )
[[ ${PV} = 9999 ]] || DOCS+=( ChangeLog )

src_prepare() {
	default
	[[ ${PV} = 9999 ]] && eautoreconf
}

src_configure() {
	# Anything else than -O0 breaks on alpha
	use alpha && replace-flags "-O?" -O0

	multilib-minimal_src_configure
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		$(multilib_native_use_enable doc doxygen) \
		$(multilib_native_use_enable doc dot) \
		--disable-werror
}

multilib_src_install_all() {
	if use doc; then
		mv "${ED%/}"/usr/share/${PN}/html "${ED%/}"/usr/share/doc/${PF} || die
		rm -r "${ED%/}"/usr/share/${PN} || die
	fi
	einstalldocs

	find "${D}" -name '*.la' -delete || die

	if use examples ; then
		find examples -iname "*.o" -delete
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
