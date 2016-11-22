# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit python-r1

DESCRIPTION="Basic Python wrapper for libcanberra"
HOMEPAGE="https://github.com/psykoyiko/pycanberra/"
PCOMMIT="88c53cd44a626ede3b07dab0b548f8bcfda42867"
SRC_URI="https://github.com/psykoyiko/pycanberra/archive/${PCOMMIT}.zip -> ${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	media-libs/libcanberra"
DEPEND="${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-${PCOMMIT}"

src_prepare() { :; }
src_compile() { :; }
src_install() {
	python_foreach_impl python_domodule pycanberra.py
	default
}
