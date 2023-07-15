# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gnat_2021 )
LLVM_MAX_SLOT=15        # Check "configure" script for supported LLVM versions.

inherit ada edo llvm toolchain-funcs

DESCRIPTION="Open-source analyzer, compiler, and simulator for VHDL 2008/93/87"
HOMEPAGE="https://ghdl.github.io/ghdl/
	https://github.com/ghdl/ghdl/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ghdl/${PN}.git"
else
	SRC_URI="https://github.com/ghdl/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="llvm"
REQUIRED_USE="${ADA_REQUIRED_USE}"

RDEPEND="
	${ADA_DEPS}
	llvm? ( <sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/patchelf
"

PATCHES=( "${FILESDIR}"/${PN}-3.0.0-no-pyunit.patch )

pkg_setup() {
	ada_pkg_setup

	use llvm && llvm_pkg_setup
}

src_prepare() {
	default

	sed -i "s|ar rc|$(tc-getAR) rc|g" Makefile.in || die
}

src_configure() {
	tc-export CC CXX

	local -a myconf=(
		--disable-werror

		--libdir=$(get_libdir)
		--prefix=/usr

		--enable-libghdl
		--enable-synth
	)

	if use llvm ; then
		myconf+=( --with-llvm-config=llvm-config )
	fi

	# Not a autotools script!
	edo sh ./configure "${myconf[@]}"
}

src_compile() {
	default

	patchelf --set-soname libghw.so lib/libghw.so || die
}
