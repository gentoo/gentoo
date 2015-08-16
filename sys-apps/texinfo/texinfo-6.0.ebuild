# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit flag-o-matic

DESCRIPTION="The GNU info program and utilities"
HOMEPAGE="http://www.gnu.org/software/texinfo/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="nls static"

RDEPEND="
	!=app-text/tetex-2*
	>=sys-libs/ncurses-5.2-r2:5=
	dev-lang/perl
	dev-perl/libintl-perl
	dev-perl/Unicode-EastAsianWidth
	dev-perl/Text-Unidecode
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	nls? ( sys-devel/gettext )"

src_configure() {
	use static && append-ldflags -static
	econf \
		--with-external-libintl-perl \
		--with-external-Unicode-EastAsianWidth \
		--with-external-Text-Unidecode \
		$(use_enable nls)
}

src_install() {
	default
	newdoc info/README README.info
}
