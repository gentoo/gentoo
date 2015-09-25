# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit autotools python-r1

DESCRIPTION="GLib binding for the D-Bus API provided by signond"
HOMEPAGE="https://01.org/gsso/"
SRC_URI="http://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc python test"

RDEPEND="
	dev-libs/glib:2
	net-libs/signond
"
DEPEND="${RDEPEND}
	dev-libs/check
	dev-util/gdbus-codegen
	python? ( ${PYTHON_DEPS} )
	doc? ( dev-util/gtk-doc )
"

DOCS=( AUTHORS NEWS README )

# needs more love
RESTRICT="test"

src_prepare() {
	if ! use doc; then
		epatch "${FILESDIR}/${P}-doc-disable.patch"
	fi

	eautoreconf
}

src_configure() {
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
