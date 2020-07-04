# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )
inherit python-r1

SRC_URI="https://dev.gentoo.org/~bircoph/distfiles/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="A library for analysing python pickles safely"
HOMEPAGE="https://github.com/CensoredUsername/picklemagic"
LICENSE="WTFPL-2"
SLOT="0"
IUSE="doc"

BDEPEND="doc? ( dev-python/sphinx )"
DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_compile() {
	use doc && emake -C doc html
}

src_install() {
	default
	python_foreach_impl python_domodule *.py
	use doc && dodoc -r doc/build/html
}
