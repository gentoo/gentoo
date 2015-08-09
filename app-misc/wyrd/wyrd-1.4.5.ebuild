# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils autotools

DESCRIPTION="Text-based front-end to Remind"
HOMEPAGE="http://pessimization.com/software/wyrd/"
SRC_URI="http://pessimization.com/software/wyrd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="unicode"

RDEPEND="
	sys-libs/ncurses[unicode?]
	>=app-misc/remind-03.01
"
DEPEND="${RDEPEND}
	>=dev-lang/ocaml-3.08
"

src_prepare() {
	epatch "${FILESDIR}/ocaml4.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable unicode utf8)
}

src_compile() {
	# no parallel build, see https://bugs.launchpad.net/wyrd/+bug/691827
	emake -j1
}

src_install() {
	export STRIP_MASK="/usr/bin/wyrd"
	emake DESTDIR="${D}" install
	dodoc ChangeLog
	dohtml doc/manual.html
}
