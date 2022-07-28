# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit meson python-any-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wmww/${PN}"
else
	SRC_URI="https://github.com/wmww/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Library to create desktop components for Wayland using the Layer Shell protocol"
HOMEPAGE="https://github.com/wmww/gtk-layer-shell"

LICENSE="MIT-with-advertising LGPL-3+"
SLOT="0"
IUSE="examples gtk-doc introspection test"
RESTRICT="!test? ( test )"

DEPEND="
	>=x11-libs/gtk+-3.24.26:3[introspection?,wayland]
	>=dev-libs/wayland-1.10.0
	>=dev-libs/wayland-protocols-1.16
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	test? ( ${PYTHON_DEPS} )
"

src_configure() {
	# note: Next 0.x release should add support for VAPI (vala)
	local emesonargs=(
		$(meson_use examples)
		$(meson_use gtk-doc docs)
		$(meson_use test tests)
		$(meson_use introspection)
	)
	meson_src_configure
}
