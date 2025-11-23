# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_pre/.}

DESCRIPTION="Input Pad for IBus"
HOMEPAGE="https://github.com/fujiwarat/input-pad/wiki"
SRC_URI="https://github.com/fujiwarat/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.gz"
S=${WORKDIR}/${PN}-${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-i18n/ibus
	dev-libs/glib:2
	dev-libs/input-pad
	virtual/libintl
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
