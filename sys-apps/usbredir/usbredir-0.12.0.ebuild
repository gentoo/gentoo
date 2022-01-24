# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_PV=${PV/_p*/}

DESCRIPTION="TCP daemon and set of libraries for usbredir protocol (redirecting USB traffic)"
HOMEPAGE="https://www.spice-space.org/usbredir.html"
SRC_URI="https://gitlab.freedesktop.org/spice/${PN}/-/archive/${P}/${PN}-${P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	virtual/libusb:1
	"
DEPEND="${RDEPEND}"
BDEPEND="
	 virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${PN}-${MY_PV}"

DOCS="TODO *.md docs/*.md"
