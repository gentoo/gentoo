# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="http://llvm.org/git/${PN}.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi

inherit python-any-r1 $GIT_ECLASS

DESCRIPTION="OpenCL C library"
HOMEPAGE="http://libclc.llvm.org/"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
else
	SRC_URI="mirror://gentoo/${P}.tar.xz ${SRC_PATCHES}"
fi

LICENSE="|| ( MIT BSD )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=sys-devel/clang-3.7:0
	>=sys-devel/llvm-3.7:0
	<sys-devel/clang-3.9:0
	<sys-devel/llvm-3.9:0"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

src_unpack() {
	if [[ $PV = 9999* ]]; then
		git-r3_src_unpack
	else
		default
		mv ${PN}-*/ ${P} || die
	fi
}

src_configure() {
	./configure.py \
		--with-llvm-config="$(type -P llvm-config)" \
		--prefix="${EPREFIX}/usr" || die
}

src_compile() {
	emake VERBOSE=1
}
