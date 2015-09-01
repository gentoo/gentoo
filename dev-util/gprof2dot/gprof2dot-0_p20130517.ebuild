# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE='xml'

inherit eutils python-r1

DESCRIPTION="Converts profiling output to dot graphs"
HOMEPAGE="https://github.com/jrfonseca/gprof2dot"
SRC_URI="http://www.hartwork.org/public/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-py3-xrange.patch
}

_make_call_script() {
	cat <<-EOF >"${D}/$1"
	#! /usr/bin/env python
	from gprof2dot import Main
	Main().main()
	EOF

	fperms a+x "$1" || die
}

src_install() {
	abi_specific_install() {
		insinto "$(python_get_sitedir)"
		doins ${PN}.py || die
		python_optimize || die
	}
	python_parallel_foreach_impl abi_specific_install

	dodir /usr/bin || die
	_make_call_script /usr/bin/${PN} || die
	python_replicate_script "${D}"/usr/bin/${PN} || die
}
