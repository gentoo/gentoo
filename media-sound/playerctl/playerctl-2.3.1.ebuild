# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 xdg-utils meson

DESCRIPTION="A CLI utility to control media players over MPRIS"
HOMEPAGE="https://github.com/acrisci/playerctl"
SRC_URI="https://github.com/acrisci/playerctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 arm64 ~x86"
IUSE="doc introspection"
RESTRICT="test" # Requires dbus-next python package that's not in the tree

RDEPEND="
	dev-libs/glib:2
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( dev-util/gtk-doc )
	dev-util/gdbus-codegen
	dev-util/glib-utils
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddatadir=share
		-Dbindir=bin
		$(meson_use doc gtk-doc)
		$(meson_use introspection)
	)

	xdg_environment_reset # 596166
	meson_src_configure
}

src_install() {
	meson_src_install
	rm "${ED}"/usr/$(get_libdir)/libplayerctl.a || die

	docinto examples
	dodoc -r "${S}"/examples/.
	docompress -x "/usr/share/doc/${PF}/examples"

	newbashcomp data/playerctl.bash "${PN}"
	insinto /usr/share/zsh/site-functions
	newins data/playerctl.zsh _playerctl
}
