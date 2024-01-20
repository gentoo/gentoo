# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Input Pad for IBus"
HOMEPAGE="https://github.com/fujiwarat/input-pad/wiki"
SRC_URI="https://github.com/fujiwarat/${PN}/releases/download/${PV}/${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-i18n/ibus
	dev-libs/glib:2
	dev-libs/input-pad
	virtual/libintl
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"

BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
