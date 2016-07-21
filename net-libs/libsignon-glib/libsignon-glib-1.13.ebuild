# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
inherit autotools python-r1 vcs-snapshot xdg-utils

DESCRIPTION="GLib binding for the D-Bus API provided by signond"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="https://gitlab.com/accounts-sso/libsignon-glib/repository/archive.tar.gz?ref=VERSION_1.13 -> ${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc python test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-libs/glib:2
	net-libs/signond
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	python? ( ${PYTHON_DEPS} )
	doc? ( dev-util/gtk-doc )
"

DOCS=( AUTHORS NEWS README )

# needs more love
RESTRICT="test"

src_prepare() {
	if ! use doc; then
		epatch "${FILESDIR}/${PN}-1.12-doc-disable.patch"
	fi

	eautoreconf
}

src_configure() {
	xdg_environment_reset

	myconfigure() {
		local myeconfargs=(
			$(use_enable debug)
			$(use_enable doc gtk-doc)
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
	# fails to compile with more than one thread
	MAKEOPTS="${MAKEOPTS} -j1"
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
}
