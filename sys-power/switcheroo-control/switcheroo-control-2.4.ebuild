# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson

DESCRIPTION="D-Bus service to check the availability of dual-GPU"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/switcheroo-control/"
SRC_URI="https://gitlab.freedesktop.org/hadess/switcheroo-control/uploads/accd4a9492979bfd91b587ae7e18d3a2/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
IUSE="gtk-doc"

KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/libgudev-232:=
	sys-apps/systemd
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "You need to run systemd and enable the service:"
		elog "# systemctl enable switcheroo-control"
	fi
}
