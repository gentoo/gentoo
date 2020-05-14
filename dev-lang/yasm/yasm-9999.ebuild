# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/yasm/yasm.git"
	inherit autotools git-r3
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

BDEPEND="
	nls? ( sys-devel/gettext )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '>=dev-python/cython-0.14[${PYTHON_USEDEP}]')
	)
"
DEPEND="
	nls? ( virtual/libintl )
"
RDEPEND="${DEPEND}
	python? ( ${PYTHON_DEPS} )
"

if [[ ${PV} == 9999* ]]; then
	BDEPEND+="
		app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
	"
fi

pkg_setup() {
	: # Avoid python-single-r1_pkg_setup
}

src_prepare() {
	default

	if [[ ${PV} == 9999* ]]; then
		eautoreconf
		./modules/arch/x86/gen_x86_insn.py || die
	fi
}

src_configure() {
	use python && python_setup

	local myconf=(
		--disable-warnerror
		$(use_enable python)
		$(use_enable python python-bindings)
		$(use_enable nls)
	)

	econf "${myconf[@]}"
}

src_test() {
	# https://bugs.gentoo.org/718870
	emake -j1 check
}
