# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

DESCRIPTION="A fast pipe/static menu generator for the Openbox Window Manager"
HOMEPAGE="https://github.com/trizen/obmenu-generator"
SRC_URI="https://github.com/trizen/obmenu-generator/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/perl[gdbm]
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

pkg_postinst() {
	optfeature_header "For icon (-i) functionality, install:"
	optfeature "support via gtk+:2 (enabled via config)" dev-perl/Gtk2
	optfeature "support via gtk+:3 (default)" dev-perl/Gtk3
}
