# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="gtk based greeter for greetd"
HOMEPAGE="https://git.sr.ht/~kennylevinsen/gtkgreet"

inherit meson

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~kennylevinsen/gtkgreet"
else
	SRC_URI="https://git.sr.ht/~kennylevinsen/gtkgreet/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+layershell"

DEPEND="
	dev-libs/json-c:=
	layershell? ( gui-libs/gtk-layer-shell )
	x11-libs/gtk+:3
"
RDEPEND="
	${DEPEND}
	gui-libs/greetd
"
BDEPEND="
	app-text/scdoc
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-0.6-r1-werror.patch )

src_configure() {
	local emesonargs=(
		-Dman-pages=enabled
		$(meson_feature layershell)
	)
	meson_src_configure
}
