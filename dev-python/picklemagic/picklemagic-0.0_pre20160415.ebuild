# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
inherit python-r1

DESCRIPTION="A library for analysing python pickles safely"
HOMEPAGE="https://github.com/CensoredUsername/picklemagic"
SRC_URI="https://dev.gentoo.org/~bircoph/distfiles/${P}.tar.xz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="doc? ( dev-python/sphinx )"
RDEPEND="${PYTHON_DEPS}"

src_compile() {
	use doc && emake -C doc html
}

src_install() {
	default
	python_foreach_impl python_domodule *.py
	use doc && dodoc -r doc/build/html
}
