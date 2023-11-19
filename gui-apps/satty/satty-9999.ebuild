# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3 desktop xdg

DESCRIPTION="A screenshot annotation tool inspired by Swappy and Flameshot."
HOMEPAGE="https://github.com/gabm/satty"
EGIT_REPO_URI="https://github.com/gabm/satty.git"

LICENSE="MPL-2.0"
SLOT="0"

RDEPEND="virtual/rust
		x11-libs/pango
		dev-libs/glib:2
		x11-libs/cairo
		gui-libs/libadwaita
		gui-libs/gtk:4
		x11-libs/gdk-pixbuf:2
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_install() {
	dodoc README.md

	if use debug ; then
		cd target/debug || die
	else
		cd target/release  || die
	fi

	dobin satty
	#Just add the icon and desktop file
	doicon "${S}/assets/satty.svg"
	domenu "${S}/satty.desktop"
}
