# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

EGIT_REPO_URI="git://anongit.freedesktop.org/libreoffice/cppunit"
[[ ${PV} = 9999 ]] && inherit git-2 autotools
inherit eutils flag-o-matic

DESCRIPTION="C++ port of the famous JUnit framework for unit testing"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/cppunit"
[[ ${PV} = 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} = 9999 ]] || \
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen[dot]
		media-gfx/graphviz
	)"

DOCS=( AUTHORS BUGS NEWS README THANKS TODO doc/FAQ )
[[ ${PV} = 9999 ]] || DOCS+=( ChangeLog )

src_prepare() {
	[[ ${PV} = 9999 ]] && eautoreconf
}

src_configure() {
	# Anything else than -O0 breaks on alpha
	use alpha && replace-flags "-O?" -O0

	econf \
		$(use_enable static-libs static) \
		$(use_enable doc doxygen) \
		$(use_enable doc dot) \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--disable-silent-rules
}

src_install() {
	default

	prune_libtool_files --all

	if use examples ; then
		find examples -iname "*.o" -delete
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
