# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 toolchain-funcs

DESCRIPTION="An assembler for x86 and x86_64 instruction sets"
HOMEPAGE="http://yasm.tortall.net/"
SRC_URI="http://www.tortall.net/projects/yasm/releases/${P}.tar.gz"

LICENSE="BSD-2 BSD || ( Artistic GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="-* amd64 ~arm64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="nls python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	python? ( $(python_gen_cond_dep '>=dev-python/cython-0.14[${PYTHON_USEDEP}]') )"

pkg_setup() {
	: # Avoid python-single-r1_pkg_setup
}

src_configure() {
	use python && python_setup

	XMLTO=: \
	econf \
		CC_FOR_BUILD=$(tc-getBUILD_CC) \
		CCLD_FOR_BUILD=$(tc-getBUILD_CC) \
		$(use_enable python) \
		$(use_enable python python-bindings) \
		$(use_enable nls)
}

src_test() {
	# https://bugs.gentoo.org/718870
	emake -j1 check
}
