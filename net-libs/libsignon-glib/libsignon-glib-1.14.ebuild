# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5,3_6} )
inherit autotools python-r1 vcs-snapshot xdg-utils

DESCRIPTION="GLib binding for the D-Bus API provided by signond"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="https://gitlab.com/accounts-sso/libsignon-glib/repository/archive.tar.gz?ref=VERSION_${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="debug doc +introspection python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} introspection )"

RDEPEND="
	dev-libs/glib:2
	net-libs/signond
	introspection? ( dev-libs/gobject-introspection:= )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/gdbus-codegen
	doc? ( dev-util/gtk-doc )
"

DOCS=( AUTHORS NEWS README.md )

# needs more love
RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-default-opts.patch" )

src_prepare() {
	default

	if ! use doc; then
		eapply "${FILESDIR}/${PN}-1.12-doc-disable.patch"
	fi

	eautoreconf
}

src_configure() {
	xdg_environment_reset

	myconfigure() {
		local myeconfargs=(
			$(use_enable debug)
			$(use_enable doc gtk-doc)
			$(use_enable introspection)
			$(use_enable python)
			$(use_enable test tests)
		)

		econf "${myeconfargs[@]}"
	}

	if use python; then
		python_copy_sources
		python_foreach_impl run_in_build_dir myconfigure
	else
		myconfigure
	fi
}

src_compile() {
	default
	if use python; then
		python_foreach_impl run_in_build_dir default
	fi
}

src_install() {
	default
	if use python; then
		python_foreach_impl run_in_build_dir default
	fi
	find "${D}" -name '*.la' -delete || die
}
