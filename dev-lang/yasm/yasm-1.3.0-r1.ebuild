# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/yasm/yasm.git"
	inherit autotools git-r3
else
	SRC_URI="http://www.tortall.net/projects/yasm/releases/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

DESCRIPTION="An assembler for x86 and x86_64 instruction sets"
HOMEPAGE="http://yasm.tortall.net/"

LICENSE="BSD-2 BSD || ( Artistic GPL-2 LGPL-2 )"
SLOT="0"
IUSE="nls"

BDEPEND="
	nls? ( sys-devel/gettext )
"
DEPEND="
	nls? ( virtual/libintl )
"
RDEPEND="${DEPEND}
"

if [[ ${PV} == 9999* ]]; then
	BDEPEND+="
		app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
		dev-lang/python
	"
fi

src_prepare() {
	default

	if [[ ${PV} == 9999* ]]; then
		eautoreconf
		python modules/arch/x86/gen_x86_insn.py || die
	fi
}

src_configure() {
	local myconf=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		CCLD_FOR_BUILD="$(tc-getBUILD_CC)"
		--disable-warnerror
		--disable-python
		--disable-python-bindings
		$(use_enable nls)
	)

	econf "${myconf[@]}"
}

src_test() {
	# https://bugs.gentoo.org/718870
	emake -j1 check
}
