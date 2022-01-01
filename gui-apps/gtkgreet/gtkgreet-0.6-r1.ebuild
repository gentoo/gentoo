# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="gtk based greeter for greetd"
HOMEPAGE="https://git.sr.ht/~kennylevinsen/gtkgreet"

inherit meson

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~kennylevinsen/gtkgreet"
else
	MY_PV=${PV/_rc/-rc}
	SRC_URI="https://git.sr.ht/~kennylevinsen/gtkgreet/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+layershell +man"

DEPEND="
	dev-libs/json-c:=
	x11-libs/gtk+:3
	layershell? ( gui-libs/gtk-layer-shell )
"
RDEPEND="
	${DEPEND}
	gui-libs/greetd
"
BDEPEND="
	virtual/pkgconfig
	man? ( app-text/scdoc )
"

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_use layershell)
	)
	meson_src_configure
}
