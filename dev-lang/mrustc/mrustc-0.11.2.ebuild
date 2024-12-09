# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo multiprocessing rust-toolchain toolchain-funcs

# The makefile needs to know the version of rust to build
RUST_VERSION=1.74.1
# We need to pretend to be this version of Rust for mrustc build and outputs
MRUSTC_RUST_VER=1.74.0

DESCRIPTION="Mutabah's Rust Compiler"
HOMEPAGE="https://github.com/thepowersgang/mrustc"

if [[ ${PV} == *"9999"* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/thepowersgang/mrustc.git"
else
	SRC_URI="https://github.com/thepowersgang/mrustc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://static.rust-lang.org/dist/rustc-${RUST_VERSION}-src.tar.xz
	"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="sys-libs/zlib"
# mrustc transpiles Rust to C, and currently the C code it generates doesn't currently work with clang
RDEPEND="
	${DEPEND}
	sys-devel/gcc:*
"
BDEPEND="sys-devel/gcc:*"

PATCHES=(
	"${FILESDIR}/${PN}-0.11.2-gcc15.patch"
	"${FILESDIR}/${PN}-0.11.2-dont-strip-bins.patch"
	"${FILESDIR}/${PN}-0.11.0-default-to-rust-1_74.patch"
	"${FILESDIR}/${PN}-0.11.0-RUSTC_SRC_PROVIDED.patch"
	"${FILESDIR}/${PN}-0.10.1-git-be-gone.patch"
)

QA_FLAGS_IGNORED="
	usr/lib/rust/${P}/bin/mrustc
	usr/lib/rust/${P}/bin/minicargo
	usr/lib/rust/${P}/lib/rustlib/$(rust_abi)/lib/*.rlib
"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && ! tc-is-gcc; then
		die "mrustc needs to be built using GCC."
	fi
}

src_configure() {
	:
}

src_compile() {
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
		-g "${S}/../rustc-${RUST_VERSION}-src/tests/ui/hello_world/main.rs" -o "${T}"/hello
	"${T}"/hello || die "Failed to run hello_world built with mrustc"
}

src_install() {
	# If we're installing into /usr/lib/rust we may as well be consistent
	into /usr/lib/rust/${P}
	dobin bin/mrustc
	dobin bin/minicargo
	local lib patch
	local libs=( "${S}"/output-*/*.rlib* )
	insinto  "/usr/lib/rust/${P}/lib/rustlib/$(rust_abi)/lib"
	# If we ever want to support mrustc stdlib for multiple rusts we'll need to
	# do something more clever here.
	for lib in "${libs[@]}"; do
		# We only want .rlib{,.hir,o}
		if [[ ${lib} != *.c && ${lib} != *.d && ${lib} != *.txt ]]; then
			doins "${lib}"
		fi
	done
	# For convenience, install files required to build various rusts
	insinto /usr/share/${P}
	doins -r "${S}/script-overrides/"
	insinto /usr/share/${P}/patches
	for patch in "${S}"/rustc-*.patch "${S}"/rustc-*-overrides.toml; do
		doins "${patch}"
	done
}
