# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Clearlooks-Phenix is a GTK+ 3 port of Clearlooks, the default theme for GNOME 2"
HOMEPAGE="https://github.com/jpfleury/clearlooks-phenix"
SRC_URI="https://github.com/jpfleury/clearlooks-phenix/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="3.6"
IUSE=""

SLOT_BLOCK="!x11-themes/clearlooks-phenix:3.4
	!x11-themes/clearlooks-phenix:0"
RDEPEND="${SLOT_BLOCK}
	>=x11-libs/gtk+-3.6:3
	x11-themes/gtk-engines"
DEPEND="app-arch/unzip"

src_install() {
	insinto "/usr/share/themes/Clearlooks-Phenix"
	doins -r *
}
