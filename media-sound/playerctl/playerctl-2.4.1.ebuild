# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 meson xdg

DESCRIPTION="A CLI utility to control media players over MPRIS"
HOMEPAGE="https://github.com/acrisci/playerctl"
SRC_URI="https://github.com/acrisci/playerctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc introspection"
RESTRICT="test" # Seems to want a system bus, rather than a session one?

RDEPEND="
	>=dev-libs/glib-2.38:2
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		-Ddatadir=share
		-Dbindir=bin
		-Dbash-completions=false
		-Dzsh-completions=false
		$(meson_use doc gtk-doc)
		$(meson_use introspection)
	)

	xdg_environment_reset # bug #596166
	meson_src_configure
}

src_install() {
	meson_src_install

	docinto examples
	dodoc -r "${S}"/examples/.
	docompress -x "/usr/share/doc/${PF}/examples"

	newbashcomp data/playerctl.bash "${PN}"
	insinto /usr/share/zsh/site-functions
	newins data/playerctl.zsh _playerctl
}
