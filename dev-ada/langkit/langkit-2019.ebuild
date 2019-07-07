# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

MYP=${P}-20190510-19B8C

DESCRIPTION="A Python framework to generate language parsers"
HOMEPAGE="https://www.adacore.com/community"
SRC_URI="http://mirrors.cdn.adacore.com/art/5cdf8f8a31e87a8f1c967d31
	-> ${MYP}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-ada/gnatcoll-bindings[iconv,shared]
	dev-python/mako
	<dev-python/pyyaml-5
	dev-python/enum34
	dev-python/funcy
	dev-python/docutils"

DEPEND="${RDEPEND}
	test? ( dev-ada/gnatcoll-bindings[gmp] )"

S="${WORKDIR}"/${MYP}-src

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_test() {
	testsuite/testsuite.py --show-error-output | tee testsuite.log
	grep -q FAILED testsuite.log && die "Test failed"
}

src_install() {
	default
	python_domodule langkit
	python_doscript scripts/create-project.py
}
