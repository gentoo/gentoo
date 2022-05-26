# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# USE="-* gtk2 gtk3 xfce" ebuild ${P}.ebuild clean compile
# cd $(portageq envvar PORTAGE_TMPDIR)/portage/x11-themes/${P}/work
# find ${P}-build/ -name "*.png" | xargs tar Jcvf /usr/portage/distfiles/${P}-pngs.tar.xz --owner=root --group=root

inherit meson toolchain-funcs

DESCRIPTION="A flat theme with transparent elements for GTK+3, GTK+2 and GNOME Shell"
HOMEPAGE="https://github.com/jnsh/arc-theme"
SRC_URI="https://github.com/jnsh/${PN}/releases/download/${PV}/arc-theme-${PV}.tar.xz
	pre-rendered? ( https://dev.gentoo.org/~chewi/distfiles/${P}-pngs.tar.xz )"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="cinnamon gnome-shell +gtk2 +gtk3 mate +pre-rendered xfce"

SASSC_DEPEND="
	dev-lang/sassc
"

SVG_DEPEND="
	!pre-rendered? (
		media-gfx/inkscape
		media-gfx/optipng
	)
"

# Supports various GTK+3, GNOME Shell, and Cinnamon versions and uses
# pkg-config to determine which set of files to build. Updates will
# therefore break existing installs but there's no way around this. At
# least GTK+3 is unlikely to see a release beyond 3.24.
BDEPEND="
	>=dev-util/meson-0.56.0
	cinnamon? (
		${SASSC_DEPEND}
		gnome-extra/cinnamon
	)
	gnome-shell? (
		${SASSC_DEPEND}
		>=gnome-base/gnome-shell-3.18
	)
	gtk2? (
		${SVG_DEPEND}
	)
	gtk3? (
		${SASSC_DEPEND}
		${SVG_DEPEND}
		virtual/pkgconfig
		=x11-libs/gtk+-3.24*:3
	)
	xfce? (
		${SVG_DEPEND}
	)
"

# gnome-themes-standard is only needed by GTK+2 for the Adwaita
# engine. This engine is built into GTK+3.
RDEPEND="
	gtk2? (
		x11-themes/gnome-themes-standard
		x11-themes/gtk-engines-murrine
	)
"

src_configure() {
	local themes=$(
		printf "%s," \
		$(usev cinnamon) \
		$(usev gnome-shell) \
		$(usev gtk2) \
		$(usev gtk3) \
		$(usex mate metacity "") \
		$(usex xfce xfwm "")
	)

	local emesonargs=(
		-Dthemes="${themes%,}"
		-Dgtk3_version=3.24
	)

	if use pre-rendered; then
		emesonargs+=(
			$(if tc-is-cross-compiler; then
				  echo --cross-file
			  else
				  echo --native-file
			  fi)
			"${FILESDIR}"/pre-rendered.ini
		)
	fi

	meson_src_configure
}

src_compile() {
	# fontconfig issue?
	# https://bugs.gentoo.org/666418#c28
	use pre-rendered ||
		addpredict "${BROOT}"/usr/share/inkscape/fonts/.uuid.TMP-XXXXXX

	meson_src_compile
}
