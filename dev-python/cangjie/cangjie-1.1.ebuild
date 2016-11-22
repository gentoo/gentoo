# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python3_4 )

inherit autotools-utils python-r1

DESCRIPTION="The Python bindings to libcangjie"
HOMEPAGE="http://cangjians.github.io"
SRC_URI="http://cangjians.github.io/downloads/pycangjie/cangjie-${PV}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${PYTHON_DEPS}
	app-i18n/libcangjie
	dev-python/cython
	>=dev-python/cython-0.14"
RDEPEND="app-i18n/libcangjie
	${PYTHON_DEPS}"

src_configure() {
	python_foreach_impl autotools-utils_src_configure
}

src_compile() {
	python_foreach_impl autotools-utils_src_compile
}

src_install() {
	python_foreach_impl autotools-utils_src_install
}
