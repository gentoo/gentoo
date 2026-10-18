# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo multiprocessing rust-toolchain toolchain-funcs

# The makefile needs to know the version of rust to build
RUST_VERSION=1.90.0
# We need to pretend to be this version of Rust for mrustc build and outputs
MRUSTC_RUST_VER=1.90.0

DESCRIPTION="Mutabah's Rust Compiler"
HOMEPAGE="https://github.com/thepowersgang/mrustc"

if [[ ${PV} == *"9999"* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/thepowersgang/mrustc.git"
	SRC_URI="https://static.rust-lang.org/dist/rustc-${RUST_VERSION}-src.tar.xz"
else
	MY_COMMIT="d85e86b199e2522d74bee19efa6ebf3af596270f"
	SRC_URI="https://github.com/thepowersgang/mrustc/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz
		https://static.rust-lang.org/dist/rustc-${RUST_VERSION}-src.tar.xz
	"
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/${PN}-${MY_COMMIT}"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="virtual/zlib:="
# mrustc transpiles Rust to C, and currently the C code it generates doesn't currently work with clang
RDEPEND="
	${DEPEND}
	sys-devel/gcc:*
"
BDEPEND="sys-devel/gcc:*"

PATCHES=(
	"${FILESDIR}/${PN}-0.11.2-dont-strip-bins.patch"
	"${FILESDIR}/${PN}-0.12.0-default-to-rust-1_90.patch"
	"${FILESDIR}/${PN}-20261018-build-with-provided-rust.patch"
	"${FILESDIR}/${PN}-0.12.0-no-glibcxx-assertions-workaround.patch"
)

if [[ ${PV} != *"9999"* ]]; then
	PATCHES+=(
		"${FILESDIR}/${PN}-0.12.0-git-be-gone.patch"
	)
fi

QA_FLAGS_IGNORED="
	usr/lib/rust/${P/_p*/}/bin/mrustc
	usr/lib/rust/${P/_p*/}/bin/minicargo
	usr/lib/rust/${P/_p*/}/lib/rustlib/$(rust_abi)/lib/*.rlib
"

src_unpack() {
	if [[ ${PV} == *"9999"* ]]; then
		default
		git-r3_src_unpack
	else
		default
	fi

}

src_configure() {
	:
}

src_compile() {
	if ! tc-is-gcc ; then
		# mrustc needs to be built using GCC
		export CC=${CHOST}-gcc
		export CXX=${CHOST}-g++
		tc-is-gcc || die "tc-is-gcc failed in spite of CC=${CC}"
	fi
	export PARLEVEL=$(makeopts_jobs)
	export RUSTC_VERSION=${MRUSTC_RUST_VER} # Pretend that we're using upstream-supported Rust
	export MRUSTC_TARGET_VER=${RUSTC_VERSION%.*}
	export RUSTCSRC="${WORKDIR}/rustc-${RUST_VERSION}-src"
	export RUSTC_SRC_PROVIDED=1
	export V='' # echo build commands in makefiles (minicargo still writes commands to file)
	# build mrustc & minicargo then use them to build the standard library
	# emake -f minicargo.mk will do everything including a full bootstrap
	emake all
	emake -C tools/minicargo/
	# It's not much, but it's enough to do a 'hello world' at least... and build dev-lang/rust!
	emake -e -f minicargo.mk LIBS
}

src_test() {
	# The main makefile test targets just do this, cut out the middleman
	emake -e -f minicargo.mk local_tests
	# build and run 'hello world' (this is called using 'test' in the makefile, but we can do it manually)
	edo "${S}"/bin/mrustc -L "${S}"/output-${MRUSTC_RUST_VER}/ \
		-g "${S}/../rustc-${RUST_VERSION}-src/tests/ui/parallel-rustc/hello_world.rs" -o "${T}"/hello
	"${T}"/hello || die "Failed to run hello_world built with mrustc"
}

src_install() {
	local p=${P/_p*/}
	# If we're installing into /usr/lib/rust we may as well be consistent
	into "/usr/lib/rust/${p}"
	dobin bin/mrustc
	dobin bin/minicargo
	local lib patch
	local libs=( "${S}"/output-*/*.rlib* )
	insinto  "/usr/lib/rust/${p}/lib/rustlib/$(rust_abi)/lib"
	# If we ever want to support mrustc stdlib for multiple rusts we'll need to
	# do something more clever here.
	for lib in "${libs[@]}"; do
		# We only want .rlib{,.hir,o}
		if [[ ${lib} != *.c && ${lib} != *.d && ${lib} != *.txt ]]; then
			doins "${lib}"
		fi
	done
	# For convenience, install files required to build various rusts
	insinto "/usr/share/${p}"
	doins -r "${S}/script-overrides/"
	insinto "/usr/share/${p}/patches"
	for patch in "${S}"/rustc-*.patch "${S}"/rustc-*-overrides.toml; do
		doins "${patch}"
	done
}
