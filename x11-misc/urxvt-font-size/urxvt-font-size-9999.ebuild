# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit multilib

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="git://github.com/majutsushi/urxvt-font-size.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/majutsushi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="Perl extension for rxvt-unicode to change the font size on the fly"
HOMEPAGE="https://github.com/majutsushi/urxvt-font-size/"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	x11-apps/xlsfonts
	x11-terms/rxvt-unicode[perl]
"

src_install() {
	insinto /usr/$(get_libdir)/urxvt/perl
	doins font-size
	dodoc README.markdown
}
