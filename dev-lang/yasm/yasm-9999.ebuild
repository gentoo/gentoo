# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-r1

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/yasm/yasm.git"
	inherit git-r3
else
	SRC_URI="http://www.tortall.net/projects/yasm/releases/${P}.tar.gz"
	KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
fi

DESCRIPTION="An assembler for x86 and x86_64 instruction sets"
HOMEPAGE="http://yasm.tortall.net/"

LICENSE="BSD-2 BSD || ( Artistic GPL-2 LGPL-2 )"
SLOT="0"
IUSE="nls python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	nls? ( virtual/libintl )
	python? ( ${PYTHON_DEPS} )"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	python? ( >=dev-python/cython-0.14[${PYTHON_USEDEP}] )"

if [[ ${PV} == 9999* ]]; then
	DEPEND="${DEPEND} ${PYTHON_DEPS} app-text/xmlto app-text/docbook-xml-dtd:4.1.2"
fi

src_prepare() {
	if ! [[ ${PV} == 9999* ]]; then
		sed -i -e 's:xmlto:&dIsAbLe:' configure.ac || die #459940
	fi
	# ksh doesn't grok $(xxx), makes aclocal fail
	sed -i -e '1c\#!/usr/bin/env sh' YASM-VERSION-GEN.sh || die
	eautoreconf

	if [[ ${PV} == 9999* ]]; then
		./modules/arch/x86/gen_x86_insn.py || die
	fi
}

src_configure() {
	if [[ ${PV} == 9999* ]]; then
		python_setup
	else
		use python && python_setup
	fi

	econf \
		--disable-warnerror \
		$(use_enable python) \
		$(use_enable python python-bindings) \
		$(use_enable nls)
}

src_test() {
	emake check
}
