# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cppunit/cppunit-9999.ebuild,v 1.8 2014/07/06 21:07:00 pinkbyte Exp $

EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/libreoffice/cppunit"
[[ ${PV} = 9999 ]] && inherit git-r3 autotools
inherit eutils flag-o-matic multilib-minimal

DESCRIPTION="C++ port of the famous JUnit framework for unit testing"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/cppunit"
[[ ${PV} = 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
# Don't move KEYWORDS on the previous line or ekeyword won't work # 399061
[[ ${PV} = 9999 ]] || \
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen[dot]
		media-gfx/graphviz
	)"

DOCS=( AUTHORS BUGS NEWS README THANKS TODO doc/FAQ )
[[ ${PV} = 9999 ]] || DOCS+=( ChangeLog )

MULTILIB_CHOST_TOOLS=(
	/usr/bin/cppunit-config
)

src_prepare() {
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
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--disable-silent-rules
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --all

	if use examples ; then
		find examples -iname "*.o" -delete
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
