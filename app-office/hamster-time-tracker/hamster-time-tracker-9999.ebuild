# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/hamster-time-tracker/hamster-time-tracker-9999.ebuild,v 1.2 2015/05/23 16:30:07 nicolasbock Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_6,2_7} )

inherit git-r3 python-single-r1 waf-utils

DESCRIPTION="Time tracking for the masses"
HOMEPAGE="http://projecthamster.wordpress.com"
EGIT_REPO_URI="https://github.com/projecthamster/hamster.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-python/gconf-python
	gnome-base/gconf[introspection]
	dev-python/pyxdg
	>=x11-libs/gtk+-3.10
	sys-devel/gettext"
DEPEND="${RDEPEND}
	dev-util/intltool"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	python_fix_shebang .
}
