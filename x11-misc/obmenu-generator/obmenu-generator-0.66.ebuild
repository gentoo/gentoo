# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A fast pipe/static menu generator for the Openbox Window Manager"
HOMEPAGE="http://trizen.go.ro/"
SRC_URI="https://github.com/trizen/obmenu-generator/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl
	dev-perl/Data-Dump
	>=dev-perl/Linux-DesktopFiles-0.90.0
	x11-wm/openbox
"

src_install() {
	dobin ${PN}
	insinto /etc/xdg/obmenu-generator
	doins schema.pl
	newdoc README.md README
}
