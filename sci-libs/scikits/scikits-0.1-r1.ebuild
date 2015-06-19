# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scikits/scikits-0.1-r1.ebuild,v 1.6 2015/04/08 18:49:16 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit python-r1

DESCRIPTION="Common files for python scikits"
HOMEPAGE="http://projects.scipy.org/scipy/scikits"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}.example/${PN}.example-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	python_moduleinto scikits
	python_foreach_impl python_domodule scikits.example*/scikits/__init__.py

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r scikits.example*/*
	fi
}
