# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 multiprocessing

MYP=${PN}-gpl-${PV}

DESCRIPTION="A Python framework to generate language parsers"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="http://mirrors.cdn.adacore.com/art/5b0cfbefc7a4475263382c2a
	-> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-ada/gnatcoll-bindings[iconv,shared]
	dev-python/mako
	dev-python/pyyaml
	<dev-python/pyyaml-5
	dev-python/enum34
	dev-python/funcy
	dev-python/docutils
	dev-python/quex"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_test() {
	testsuite/testsuite.py -j $(makeopts_jobs) --show-error-output | tee testsuite.log
	grep -q FAILED testsuite.log && die "Test failed"
}

src_install() {
	default
	python_domodule langkit
	python_doscript scripts/create-project.py
}
