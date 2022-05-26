# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="TCP daemon and set of libraries for usbredir protocol (redirecting USB traffic)"
HOMEPAGE="https://www.spice-space.org/usbredir.html https://gitlab.freedesktop.org/spice/usbredir"
SRC_URI="https://gitlab.freedesktop.org/spice/usbredir/-/archive/${P}/${PN}-${P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 ~riscv ~sparc x86"

DEPEND="dev-libs/glib:2
	virtual/libusb:1"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/usbredir-${P}"

src_install() {
	meson_src_install
	dodoc -r docs/.
}
