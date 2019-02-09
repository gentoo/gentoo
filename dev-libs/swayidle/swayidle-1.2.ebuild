# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Idle management daemon for Wayland"
HOMEPAGE="https://github.com/swaywm/swayidle"
SRC_URI="https://github.com/swaywm/swayidle/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd elogind zsh-completion bash-completion fish-completion +doc"
REQUIRED_USE="?? ( elogind systemd )"

RDEPEND="dev-libs/wayland
	elogind? ( >=sys-auth/elogind-237 )
	systemd? ( >=sys-apps/systemd-237 )
"
DEPEND="${RDEPEND}
	>=dev-libs/wayland-protocols-1.14
	doc? ( app-text/scdoc )
	!<dev-libs/sway-1.0_rc1
"
src_configure() {
	local emesonargs=(
		-Dman-pages=$(usex doc enabled disabled)
		-Dzsh-completions=$(usex zsh-completion true false)
		-Dbash-completions=$(usex bash-completion true false)
		-Dfish-completions=$(usex fish-completion true false)
	)
	if use systemd ; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=systemd")
	elif use elogind ; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=elogind")
	else
		emesonargs+=("-Dlogind=disabled")
	fi

	meson_src_configure
}
