# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_6} )
PYTHON_REQ_USE='xml'

inherit eutils python-r1

MY_PV=0_p${PV//./}
MY_P=${PN}-${MY_PV}
DESCRIPTION="Converts profiling output to dot graphs"
HOMEPAGE="https://github.com/jrfonseca/gprof2dot"
SRC_URI="http://www.hartwork.org/public/${MY_P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${MY_P}-py3-xrange.patch
}

_make_call_script() {
	cat <<-EOF >"${ED}/$1"
	#! /usr/bin/env python
	from gprof2dot import Main
	Main().main()
	EOF

	fperms a+x "$1"
}

src_install() {
	abi_specific_install() {
		local sitedir="$(python_get_sitedir)"
		insinto ${sitedir#"${EPREFIX}"}
		doins ${PN}.py
		python_optimize || die
	}
	python_foreach_impl abi_specific_install

	dodir /usr/bin
	_make_call_script /usr/bin/${PN} || die
	python_replicate_script "${ED}"/usr/bin/${PN} || die
}
