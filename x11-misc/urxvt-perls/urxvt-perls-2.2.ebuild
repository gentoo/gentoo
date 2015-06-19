# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/urxvt-perls/urxvt-perls-2.2.ebuild,v 1.1 2015/05/16 19:42:28 radhermit Exp $

EAPI=5

inherit multilib

DESCRIPTION="Perl extensions for rxvt-unicode"
HOMEPAGE="https://github.com/muennich/urxvt-perls"
SRC_URI="https://github.com/muennich/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="x11-misc/xsel
	x11-terms/rxvt-unicode[perl]"

src_install() {
	insinto /usr/$(get_libdir)/urxvt/perl
	doins clipboard keyboard-select url-select
	dodoc README.md
}
