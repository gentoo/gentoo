# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{8..10} )

inherit meson distutils-r1

DESCRIPTION="A utility for viewing problems that have occurred with the system"
HOMEPAGE="https://github.com/abrt/gnome-abrt"
SRC_URI="https://github.com/abrt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"

RDEPEND="
	>=x11-libs/gtk+-3.10.0:3
	>=dev-libs/libreport-2.14.0:0=[python,${PYTHON_USEDEP}]
	>=app-admin/abrt-2.14.0
	>=dev-python/pygobject-3.29.1:3[${PYTHON_USEDEP}]
	>=dev-python/pyxdg-0.19[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
	virtual/pkgconfig
	>=sys-devel/gettext-0.17
"

python_configure() {
	local emesonargs=(
		$(meson_use doc docs)
		-Dlint=false
	)

	meson_src_configure
}

python_compile() {
	meson_src_compile
}

python_test() {
	meson_src_test
}

python_install() {
	meson_src_install
}
