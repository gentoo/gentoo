# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils toolchain-funcs python-any-r1

DESCRIPTION="Intel SPMD Program Compiler"
HOMEPAGE="https://ispc.github.com/"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/ispc/ispc.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		http://dev.gentoo.org/~ottxor/dist/${P}-llvm-3.7.patch.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD BSD-2 UoI-NCSA"
SLOT="0"
IUSE="examples"

RDEPEND="
	>=sys-devel/clang-3.7
	>=sys-devel/llvm-3.7
	<sys-devel/clang-3.8
	<sys-devel/llvm-3.8
	"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	sys-devel/bison
	sys-devel/flex
	"

src_prepare(){
	epatch "${WORKDIR}/${P}-llvm-3.7.patch"
}

src_compile() {
	sed -i '/^\t@/s/@//' Makefile || die #make all slient commands ("@") verbose
	emake LDFLAGS="${LDFLAGS}" OPT="${CXXFLAGS}" CXX="$(tc-getCXX)" CPP="$(tc-getCPP)"
}

src_install() {
	dobin ispc
	dodoc README.rst

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		docompress -x "/usr/share/doc/${PF}/examples"
		doins -r examples/*
	fi
}
