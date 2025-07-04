# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TVIGNAUD
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="Simple interface to GTK+ 3's complex MVC list widget"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	dev-perl/Gtk3
"
BDEPEND="${RDEPEND}"
