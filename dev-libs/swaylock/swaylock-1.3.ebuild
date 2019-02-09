# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps meson

DESCRIPTION="Screen locker for Wayland"
HOMEPAGE="https://github.com/swaywm/swaylock"
SRC_URI="https://github.com/swaywm/swaylock/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pam +gdk-pixbuf zsh-completion bash-completion fish-completion +doc"

RDEPEND="dev-libs/wayland
	x11-libs/libxkbcommon
	x11-libs/cairo
	gdk-pixbuf? ( x11-libs/gdk-pixbuf:2[jpeg] )
	pam? ( virtual/pam )
"
DEPEND="${RDEPEND}
	>=dev-libs/wayland-protocols-1.14
	doc? ( app-text/scdoc )
	!<dev-libs/sway-1.0_rc1
"
src_configure() {
	local emesonargs=(
		-Dman-pages=$(usex doc enabled disabled)
		-Dpam=$(usex pam enabled disabled)
		-Dgdk-pixbuf=$(usex gdk-pixbuf enabled disabled)
		$(meson_use bash-completion bash-completions)
		$(meson_use fish-completion fish-completions)
		$(meson_use zsh-completion zsh-completions)
		-Dswaylock-version=${PV}
	)

	meson_src_configure
}

pkg_postinst() {
	if ! use pam; then
		fcaps cap_sys_admin usr/bin/swaylock
	fi
}
