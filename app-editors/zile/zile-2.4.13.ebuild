# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Zile is a small Emacs clone"
HOMEPAGE="https://www.gnu.org/software/zile/"
SRC_URI="mirror://gnu/zile/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="acl test"

RDEPEND=">=dev-libs/boehm-gc-7.2:=
	sys-libs/ncurses:0=
	acl? ( virtual/acl )"

DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

QA_AM_MAINTAINER_MODE=".*help2man.*" #450278

src_configure() {
	# --without-emacs to suppress tests for GNU Emacs #630652
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--without-emacs \
		$(use_enable acl)
}

src_install() {
	emake DESTDIR="${D}" install

	# AUTHORS, FAQ, and NEWS are installed by the build system
	dodoc README THANKS

	# Zile should never install charset.alias (even on non-glibc arches)
	rm -f "${ED}"/usr/lib/charset.alias
}
