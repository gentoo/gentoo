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

inherit fcaps meson

DESCRIPTION="Screen locker for Wayland"
HOMEPAGE="https://swaywm.org"

LICENSE="MIT"
SLOT="0"
IUSE="fish-completion +gdk-pixbuf +man +pam zsh-completion"

DEPEND="dev-libs/wayland
	x11-libs/cairo
	x11-libs/libxkbcommon
	gdk-pixbuf? ( x11-libs/gdk-pixbuf:2 )
	pam? ( virtual/pam )"
RDEPEND="${DEPEND}
	!<=dev-libs/sway-1.0_beta2[swaylock]"
BDEPEND=">=dev-libs/wayland-protocols-1.14
	>=dev-util/meson-0.48
	virtual/pkgconfig
	man? ( app-text/scdoc )"

src_configure() {
	local emesonargs=(
		-Dgdk-pixbuf=$(usex gdk-pixbuf enabled disabled)
		-Dpam=$(usex pam enabled disabled)
		-Dman-pages=$(usex man enabled disabled)
		-Dfish-completions=$(usex fish-completion true false)
		-Dzsh-completions=$(usex zsh-completion true false)
		"-Dbash-completions=true"
		"-Dwerror=false"
	)

	meson_src_configure
}

pkg_postinst() {
	if ! use pam ; then
		fcaps cap_sys_admin usr/bin/swaylock
	fi
}
