# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Perl extensions for rxvt-unicode"
HOMEPAGE="https://github.com/xyb3rt/urxvt-perls"
SRC_URI="https://github.com/xyb3rt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="deprecated"

RDEPEND="x11-misc/xsel
	x11-terms/rxvt-unicode[perl]"

src_install() {
	insinto /usr/$(get_libdir)/urxvt/perl
	doins keyboard-select

	use deprecated && doins deprecated/{clipboard,url-select}

	einstalldocs
}
