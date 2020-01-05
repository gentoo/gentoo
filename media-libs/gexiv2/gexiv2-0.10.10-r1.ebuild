# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )

inherit meson python-r1 vala xdg-utils

DESCRIPTION="GObject-based wrapper around the Exiv2 library"
HOMEPAGE="https://wiki.gnome.org/Projects/gexiv2"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gexiv2.git"
	inherit git-r3
else
	SRC_URI="mirror://gnome/sources/${PN}/$(ver_cut 1-2)/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 sparc x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="gtk-doc +introspection python static-libs test +vala"
REQUIRED_USE="
	python? ( introspection ${PYTHON_REQUIRED_USE} )
	test? ( python introspection )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.38.0:2
	>=media-gfx/exiv2-0.21:=
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	test? (
		dev-python/pygobject:3
		media-gfx/exiv2[xmp]
	)
	vala? ( $(vala_depend) )
"

PATCHES=(
	# renames meson options to current git HEAD's names, current naming scheme
	# is rather awkward
	"${FILESDIR}"/${PN}-0.10.10-meson-fixup.patch
	"${FILESDIR}"/${PN}-0.10.10-vala-fixup.patch
)

src_prepare() {
	xdg_environment_reset
	use vala && vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		$(meson_use vala vapi)
		$(meson_use gtk-doc gtk_doc)
		# prevents installation of python modules (uses install_data from meson
		# which does not optimize the modules
		-Dpython2-girdir=no
		-Dpython3-girdir=no
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use python ; then
		python_moduleinto gi/overrides/
		python_foreach_impl python_domodule GExiv2.py
	fi
}
