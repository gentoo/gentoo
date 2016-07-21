# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Clearlooks-Phenix is a GTK+ 3 port of Clearlooks, the default theme for GNOME 2"
HOMEPAGE="http://www.jpfleury.net/en/software/clearlooks-phenix.php"
SRC_URI="https://github.com/jpfleury/clearlooks-phenix/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-3.10.0:3
	x11-themes/gtk-engines"

src_install() {
	insinto "/usr/share/themes/Clearlooks-Phenix"
	doins -r *
}
