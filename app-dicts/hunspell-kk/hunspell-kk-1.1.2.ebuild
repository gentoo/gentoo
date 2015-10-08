# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils git-r3 vcs-snapshot

MY_P=${PN}-${PV}

DESCRIPTION="Kazakh dictionaries for myspell/hunspell"
SRC_URI="https://github.com/kergalym/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="http://hunspell.sourceforge.net/"

SLOT="0"
LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
IUSE="ncurses nls readline static-libs"
KEYWORDS="~x86 ~amd64"

RDEPEND="
	ncurses? ( sys-libs/ncurses:= )
	readline? ( sys-libs/readline:= )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	app-text/hunspell
	app-dicts/myspell-en
	app-dicts/myspell-ru"

S=${WORKDIR}/${MY_P}

src_install() {
	dodir "/usr/share/myspell"
	insinto "/usr/share/myspell"
	doins "${S}/kk_KZ.aff"
	doins "${S}/kk_noun_adj.aff"
	doins "${S}/kk_test.aff"
	doins "${S}/kk_noun_adj.dic"
	doins "${S}/kk_test.dic"
	doins "${S}/kk_KZ.dic"
	dodoc README_kk_KZ.txt
}
