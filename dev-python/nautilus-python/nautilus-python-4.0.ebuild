# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit gnome2 meson python-single-r1

DESCRIPTION="Python bindings for the Nautilus file manager"
HOMEPAGE="https://projects.gnome.org/nautilus-python/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~ppc64 ~x86"
IUSE="gtk-doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Require pygobject:3 and USE=introspection on nautilus for sanity,
# because no (user) plugins could work without them; meson.build
# requires pygobject:3 and >=nautilus-43.0
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	>=gnome-base/nautilus-43.0[introspection]
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( dev-util/gtk-doc )
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature gtk-doc docs)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	mv "${ED}/usr/share/doc/${PN}/"* "${ED}/usr/share/doc/${P}" || die
	rm -d "${ED}/usr/share/doc/${PN}" || die

	# Directory for systemwide extensions
	keepdir /usr/share/nautilus-python/extensions
}
