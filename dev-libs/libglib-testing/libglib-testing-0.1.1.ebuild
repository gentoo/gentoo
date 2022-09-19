# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson

DESCRIPTION="Libglib-testing is a test library providing test harnesses and mock classes"
HOMEPAGE="https://gitlab.gnome.org/pwithnall/libglib-testing"
SRC_URI="https://tecnocode.co.uk/downloads/libglib-testing-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-libs/glib-2.44:2"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/gtk-doc"

src_configure() {
	local emesonargs=(
		-Dinstalled_tests=false
	)
	meson_src_configure
}
