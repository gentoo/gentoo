# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Tree widgets for urwid"
HOMEPAGE="https://github.com/pazz/urwidtrees"
SRC_URI="
	https://github.com/pazz/urwidtrees/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND=">=dev-python/urwid-1.1.0[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${P}-no-mock-dep.patch #770391
)

distutils_enable_sphinx docs/source

src_prepare() {
	find -name '*.py' -exec \
		sed -i -e '1i# -*- coding: utf-8 -*-' {} + || die

	distutils-r1_src_prepare

	local md
	for md in *.md; do
		mv "${md}" "${md%.md}" || die
	done
}
