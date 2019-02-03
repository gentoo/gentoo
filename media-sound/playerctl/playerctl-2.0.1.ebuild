# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg-utils

DESCRIPTION="A CLI utility to control media players over MPRIS"
HOMEPAGE="https://github.com/acrisci/playerctl"
SRC_URI="https://github.com/acrisci/playerctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc introspection"

RDEPEND="
	dev-libs/glib:2
	introspection? ( dev-libs/gobject-introspection:= )
"
# Override the meson dependency in MESON_DEPEND of meson.eclass
# The eclass depends on '>=dev-util/meson-0.40.0' as of writing this
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/meson-0.46.0
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use doc gtk-doc)
		$(meson_use introspection)
	)

	xdg_environment_reset # 596166
	meson_src_configure
}

src_install() {
	meson_src_install
	docinto examples
	dodoc -r "${S}"/examples/.
	docompress -x "/usr/share/doc/${PF}/examples"
}
