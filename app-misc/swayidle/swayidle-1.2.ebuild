# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/swaywm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit meson

DESCRIPTION="Idle management daemon for Wayland"
HOMEPAGE="https://swaywm.org"

LICENSE="MIT"
SLOT="0"
IUSE="elogind fish-completion +man systemd zsh-completion"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="dev-libs/wayland
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )"
RDEPEND="${DEPEND}
	!<=dev-libs/sway-1.0_beta1
	!~dev-libs/sway-1.0_beta2[swayidle]"
BDEPEND=">=dev-libs/wayland-protocols-1.14
	>=dev-util/meson-0.48
	virtual/pkgconfig
	man? ( app-text/scdoc )"

src_configure() {
	local emesonargs=(
		-Dman-pages=$(usex man enabled disabled)
		-Dfish-completions=$(usex fish-completion true false)
		-Dzsh-completions=$(usex zsh-completion true false)
		"-Dbash-completions=true"
		"-Dwerror=false"
	)
	if use systemd ; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=systemd")
	elif use elogind ; then
		emesonargs+=("-Dlogind=enabled" "-Dlogind-provider=systemd")
	else
		emesonargs+=("-Dlogind=disabled")
	fi

	meson_src_configure
}
