# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

MY_PN="kasumi-unicode"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Anthy-unicode dictionary maintenance tool"
HOMEPAGE="https://github.com/fujiwarat/kasumi-unicode/"
SRC_URI="https://github.com/fujiwarat/kasumi-unicode/releases/download/${PV}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~riscv ~sparc ~x86"

RDEPEND="
	app-i18n/anthy-unicode
	dev-libs/glib:2
	virtual/libiconv
	virtual/libintl
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
