# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit python-r1

DESCRIPTION="DesktopEntry eXecution - tool to manage and launch autostart entries"
HOMEPAGE="http://e-jc.de/"
SRC_URI="https://github.com/jceb/dex/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# https://github.com/jceb/dex/issues/37

RESTRICT="test"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( dev-python/sphinx )"

src_compile() {
	# Makefile is for creating man page only
	use doc && emake
}

src_test() {
	dex_test() {
		./dex --test 2>&1 | tee test.log || die
		if grep -q "Failed example" test.log ; then
			die "Tests failed with ${EPYTHON}"
		fi
	}

	python_foreach_impl dex_test
}

src_install() {
	dobin dex
	python_replicate_script "${ED}/usr/bin/dex"
	dodoc CHANGELOG.md README.rst
	use doc && doman dex.1
}
