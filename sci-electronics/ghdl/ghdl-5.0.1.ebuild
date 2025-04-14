# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_14 )
LLVM_COMPAT=( {18..19} )  # Check configure script for supported LLVM versions.

inherit ada edo llvm-r1 toolchain-funcs

DESCRIPTION="Open-source analyzer, compiler, and simulator for VHDL 2008/93/87"
HOMEPAGE="https://ghdl.github.io/ghdl/
	https://github.com/ghdl/ghdl/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ghdl/${PN}.git"
else
	SRC_URI="https://github.com/ghdl/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="llvm +static-libs"

# The LLVM backend requires static libraries to work, see bug: https://bugs.gentoo.org/938171
REQUIRED_USE="${ADA_REQUIRED_USE} llvm? ( static-libs )"

RDEPEND="
	${ADA_DEPS}
	llvm? (
		$(llvm_gen_dep '
			llvm-core/llvm:${LLVM_SLOT}=
		')
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/patchelf
"

PATCHES=( "${FILESDIR}/${PN}-4.0.0_pre20231218-no-pyunit.patch" )

pkg_setup() {
	ada_pkg_setup

	use llvm && llvm-r1_pkg_setup
}

src_prepare() {
	default

	sed -i "s|ar rc|$(tc-getAR) rc|g" Makefile.in || die
}

src_configure() {
	tc-export CC CXX

	local -a myconf=(
		# Build.
		--disable-werror

		# Install location.
		--libdir=$(get_libdir)
		--prefix="/usr"

		# Features.
		--enable-libghdl
		--enable-synth
	)

	if use llvm ; then
		myconf+=(
			--with-llvm-config="llvm-config"
		)
	fi

	# Not a autotools script!
	edo sh ./configure "${myconf[@]}"
}

src_compile() {
	default

	patchelf --set-soname libghw.so lib/libghw.so || die
}

src_install() {
	default

	if ! use static-libs ; then
		find "${ED}" -type f -name '*.a' -delete || die
	fi
}
