# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/wyrd/wyrd-1.4.6.ebuild,v 1.3 2015/08/03 12:55:18 ago Exp $

EAPI=5

DESCRIPTION="Text-based front-end to Remind"
HOMEPAGE="http://pessimization.com/software/wyrd/"
SRC_URI="http://pessimization.com/software/wyrd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="unicode"

RDEPEND="
	sys-libs/ncurses[unicode?]
	>=app-misc/remind-03.01
	|| ( dev-ml/camlp4:= <dev-lang/ocaml-4.02.0 )
"
DEPEND="${RDEPEND}
	>=dev-lang/ocaml-3.08
"

src_configure() {
	econf \
		$(use_enable unicode utf8)
}

src_install() {
	export STRIP_MASK="/usr/bin/wyrd"
	emake DESTDIR="${D}" install
	dodoc ChangeLog
	dohtml doc/manual.html
}
