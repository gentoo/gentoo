# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A library for complex text layout"
HOMEPAGE="https://github.com/HOST-Oman/libraqm/"
SRC_URI="https://github.com/HOST-Oman/libraqm/releases/download/v${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~x86"
IUSE="gtk-doc test"
RESTRICT="!test? ( test )"

DEPEND="
	>=media-libs/freetype-2.11.0:2
	>=media-libs/harfbuzz-3.0.0:=
	>=dev-libs/fribidi-1.0.6
"
RDEPEND="${DEPEND}"
BDEPEND="
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		# sheenbidi not packaged
		-Dsheenbidi=false
		$(meson_use gtk-doc docs)
		$(meson_use test tests)
	)
	meson_src_configure
}
