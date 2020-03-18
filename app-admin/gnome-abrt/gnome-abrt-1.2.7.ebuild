# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit autotools python-r1

DESCRIPTION="A utility for viewing problems that have occurred with the system"
HOMEPAGE="https://github.com/abrt/gnome-abrt"
SRC_URI="https://github.com/abrt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=x11-libs/gtk+-3.10.0:3
	>=dev-libs/libreport-2.0.20[python,${PYTHON_USEDEP}]
	>=app-admin/abrt-2.10.10-r1
	>=dev-python/pygobject-3.29.1:3[${PYTHON_USEDEP}]
	x11-libs/libX11
	>=dev-python/pyxdg-0.19[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	>=sys-devel/gettext-0.17
"

src_prepare() {
	default
	./gen-version > gnome-abrt-version || die
	eautoreconf
	python_copy_sources
}

src_configure() {
	myeconfargs=(
		--localstatedir="${EPREFIX}/var"
		--with-nopylint
	)

	python_foreach_impl run_in_build_dir econf "${myeconfargs[@]}"
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default
	find "${D}" -name '*.la' -type f -delete || die
}
