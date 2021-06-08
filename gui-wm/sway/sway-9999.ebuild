# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="i3-compatible Wayland window manager"
HOMEPAGE="https://swaywm.org"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	MY_PV=${PV/_rc/-rc}
	SRC_URI="https://github.com/swaywm/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="fish-completion +man +swaybar +swaybg +swayidle +swaylock +swaymsg +swaynag tray wallpapers X zsh-completion"

DEPEND="
	>=dev-libs/json-c-0.13:0=
	>=dev-libs/libinput-1.6.0:0=
	sys-auth/seatd:=
	dev-libs/libpcre
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	media-libs/mesa[gles2,libglvnd(+)]
	swaybar? ( x11-libs/gdk-pixbuf:2 )
	swaybg? ( gui-apps/swaybg )
	swayidle? ( gui-apps/swayidle )
	swaylock? ( gui-apps/swaylock )
	wallpapers? ( x11-libs/gdk-pixbuf:2[jpeg] )
	X? ( x11-libs/libxcb:0= )
"
if [[ ${PV} == 9999 ]]; then
	DEPEND+="~gui-libs/wlroots-9999:=[X=]"
else
	DEPEND+="
		>=gui-libs/wlroots-0.14:=[X=]
		<gui-libs/wlroots-0.15:=[X=]
	"
fi
RDEPEND="
	x11-misc/xkeyboard-config
	${DEPEND}
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.14
	>=dev-util/meson-0.53.0
	virtual/pkgconfig
"
if [[ ${PV} == 9999 ]]; then
	BDEPEND+="man? ( ~app-text/scdoc-9999 )"
else
	BDEPEND+="man? ( >=app-text/scdoc-1.9.3 )"
fi

src_prepare() {
	default

	use swaybar || sed -e "s/subdir('swaybar')//g" -e "/sway-bar.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaybar/d" -i meson.build || die
	use swaymsg || sed -e "s/subdir('swaymsg')//g" -e "/swaymsg.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaymsg/d" -i meson.build || die
	use swaynag || sed -e "s/subdir('swaynag')//g" -e "/swaynag.[0-9].scd/d" \
		-e "/completions\/[a-z]\+\/_\?swaynag/d" -i meson.build || die
}

src_configure() {
	local emesonargs=(
		-Dman-pages=$(usex man enabled disabled)
		-Dtray=$(usex tray enabled disabled)
		-Dxwayland=$(usex X enabled disabled)
		$(meson_use wallpapers default-wallpaper)
		$(meson_use fish-completion fish-completions)
		$(meson_use zsh-completion zsh-completions)
		"-Dbash-completions=true"
		"-Dwerror=false"
	)

	if use swaybar; then
		emesonargs+=("-Dgdk-pixbuf=enabled")
	else
		emesonargs+=("-Dgdk-pixbuf=disabled")
	fi

	meson_src_configure
}
