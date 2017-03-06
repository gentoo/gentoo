# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils llvm python-any-r1

MY_P=llvm-${PV/_/}
DESCRIPTION="OCaml bindings for LLVM"
HOMEPAGE="http://llvm.org/"
SRC_URI="http://www.llvm.org/pre-releases/${PV/_//}/${MY_P/_/}.src.tar.xz"

# Keep in sync with sys-devel/llvm
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

LICENSE="UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test ${ALL_LLVM_TARGETS[*]}"

RDEPEND="
	>=dev-lang/ocaml-4.00.0:0=
	dev-ml/ocaml-ctypes:=
	~sys-devel/llvm-${PV}:=[${LLVM_TARGET_USEDEPS// /,}]
	!sys-devel/llvm[ocaml(-)]"
# configparser-3.2 breaks the build (3.3 or none at all are fine)
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-ml/findlib
	test? ( dev-ml/ounit
		$(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]") )
	!!<dev-python/configparser-3.3.0.2
	${PYTHON_DEPS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( ${ALL_LLVM_TARGETS[*]} )"

S=${WORKDIR}/${MY_P/_/}.src

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	! use test \
		|| has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	# Python is needed to run tests using lit
	python_setup

	# User patches
	eapply_user
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DBUILD_SHARED_LIBS=ON
		-DLLVM_OCAML_OUT_OF_TREE=ON
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_BUILD_TESTS=$(usex test)

		# disable various irrelevant deps and settings
		-DLLVM_ENABLE_FFI=OFF
		-DLLVM_ENABLE_TERMINFO=OFF
		-DHAVE_HISTEDIT_H=NO
		-DWITH_POLLY=OFF
		-DLLVM_ENABLE_ASSERTIONS=OFF
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON

		-DLLVM_HOST_TRIPLE="${CHOST}"

		# disable go bindings
		-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND

		# TODO: ocamldoc
	)

	use test && mycmakeargs+=(
		-DLIT_COMMAND="${EPREFIX}/usr/bin/lit"
	)

	cmake-utils_src_configure

	local llvm_libdir=$(llvm-config --libdir)
	# an ugly hack; TODO: figure out a way to pass -L to ocaml...
	cd "${BUILD_DIR}/${libdir}" || die
	ln -s "${llvm_libdir}"/*.so . || die

	if use test; then
		local llvm_bindir=$(llvm-config --bindir)
		# Force using system-installed tools.
		sed -i -e "/llvm_tools_dir/s@\".*\"@\"${llvm_bindir}\"@" \
			"${BUILD_DIR}"/test/lit.site.cfg || die
	fi
}

src_compile() {
	cmake-utils_src_compile ocaml_all
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check-llvm-bindings-ocaml
}

src_install() {
	DESTDIR="${D}" \
	cmake -P "${BUILD_DIR}"/bindings/ocaml/cmake_install.cmake || die

	dodoc bindings/ocaml/README.txt
}
