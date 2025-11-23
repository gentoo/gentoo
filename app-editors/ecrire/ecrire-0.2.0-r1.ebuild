# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="A simple Notepad-like text editor using EFL"
HOMEPAGE="https://www.enlightenment.org"
SRC_URI="https://download.enlightenment.org/rel/apps/ecrire/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

DEPEND="|| ( dev-libs/efl[X] dev-libs/efl[wayland] )
	>=dev-libs/efl-1.26.1"
RDEPEND="${DEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

src_configure() {
	local emesonargs=( $(meson_use nls) )
	meson_src_configure
}
