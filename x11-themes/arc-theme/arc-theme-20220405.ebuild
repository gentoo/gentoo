# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit meson python-any-r1

DESCRIPTION="A flat theme with transparent elements for GTK 2/3/4 and GNOME Shell"
HOMEPAGE="https://github.com/jnsh/arc-theme"
SRC_URI="https://github.com/jnsh/${PN}/releases/download/${PV}/arc-theme-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="cinnamon gnome-shell +gtk2 +gtk3 +gtk4 mate +transparency xfce"

GLIB_DEPEND="dev-libs/glib"
SASSC_DEPEND="dev-lang/sassc"

# Supports various GTK, GNOME Shell, and Cinnamon versions and uses
# --version option for gnome-shell and cinnamon to determine which set of files to build.
# Updates will therefore break existing installs but there's no way around this.
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/meson-0.56.0
	cinnamon? (
		${SASSC_DEPEND}
		gnome-extra/cinnamon
	)
	gnome-shell? (
		${GLIB_DEPEND}
		${SASSC_DEPEND}
		>=gnome-base/gnome-shell-3.28
	)
	gtk3? (
		${GLIB_DEPEND}
		${SASSC_DEPEND}
	)
	gtk4? (
		${GLIB_DEPEND}
		${SASSC_DEPEND}
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
	# Cinnamon still uses metacity themes for its window manager.
	# so we enable metacity theme too if USE=cinnamon
	# but only enable metacity if USE=mate
	local themes=$(
		printf "%s," \
		$(usev cinnamon "cinnamon metacity") \
		$(usev gnome-shell) \
		$(usev gtk2) \
		$(usev gtk3) \
		$(usev gtk4) \
		$(! use cinnamon && usev mate metacity) \
		$(usev xfce xfwm)
	)

	local emesonargs=(
		-Dthemes="${themes%,}"
		$(meson_use gnome-shell gnome_shell_gresource)
		$(meson_use transparency)
	)

	meson_src_configure
}
