# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit bash-completion-r1 versionator

DESCRIPTION="Generate highlighted source code as an (x)html document"
HOMEPAGE="http://www.gnu.org/software/src-highlite/source-highlight.html"
SRC_URI="mirror://gnu/src-highlite/${P}.tar.gz"
LICENSE="GPL-3"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
SLOT="0"
IUSE="doc static-libs"

DEPEND=">=dev-libs/boost-1.52.0-r1[threads]
	dev-util/ctags"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--with-boost-regex="boost_regex" \
		--without-bash-completion \
		$(use_enable static-libs static)
}

src_install () {
	DOCS="AUTHORS ChangeLog CREDITS NEWS README THANKS TODO.txt"
	default

	use static-libs || rm -rf "${D}"/usr/lib*/*.la

	dobashcomp completion/source-highlight

	# That's not how we want it
	rm -fr "${ED}/usr/share"/{aclocal,doc}
	use doc &&  dohtml -A java doc/*.{html,css,java}
}

src_test() {
	export LD_LIBRARY_PATH="${S}/lib/srchilite/.libs/"
	default
}
