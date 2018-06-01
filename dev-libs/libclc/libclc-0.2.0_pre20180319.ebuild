# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

EGIT_REPO_URI="http://llvm.org/git/${PN}.git
	https://github.com/llvm-mirror/${PN}.git"
EGIT_COMMIT="96d10f2e9ec4c87d6b8d91e01d4d061915413f3e"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
else
	GIT_ECLASS="vcs-snapshot"
fi

inherit llvm prefix python-any-r1 toolchain-funcs ${GIT_ECLASS}

DESCRIPTION="OpenCL C library"
HOMEPAGE="http://libclc.llvm.org/"

if [[ ${PV} = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
else
	SRC_URI="https://github.com/llvm-mirror/libclc/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
		${SRC_PATCHES}"
fi

LICENSE="|| ( MIT BSD )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

RDEPEND="
	|| (
		sys-devel/clang:6
		sys-devel/clang:5
		sys-devel/clang:4
		>=sys-devel/clang-3.9:0
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

LLVM_MAX_SLOT=6

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	default
	if use prefix; then
		hprefixify configure.py
	fi
}

pkg_setup() {
	# we do not need llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	./configure.py \
		--with-cxx-compiler="$(tc-getCXX)" \
		--with-llvm-config="$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config" \
		--prefix="${EPREFIX}/usr" || die
}

src_compile() {
	emake VERBOSE=1
}
