# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A fast pipe/static menu generator for the Openbox Window Manager"
HOMEPAGE="https://github.com/trizen/obmenu-generator"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

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

	dodoc README.md
}
