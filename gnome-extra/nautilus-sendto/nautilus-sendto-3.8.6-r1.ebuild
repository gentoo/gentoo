# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson

DESCRIPTION="A nautilus extension for sending files to locations"
HOMEPAGE="https://gitlab.gnome.org/Archive/nautilus-sendto"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.25.9:2"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/fix-build-with-meson-0.61.patch )

pkg_postinst() {
	if ! has_version "gnome-base/nautilus[sendto]"; then
		einfo "Note that ${CATEGORY}/${PN} is meant to be used as a helper by gnome-base/nautilus[sendto]"
	fi
}
