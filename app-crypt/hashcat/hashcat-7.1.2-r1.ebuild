# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.3
	bindgen@0.72.0
	bitflags@2.9.2
	block-buffer@0.10.4
	cexpr@0.6.0
	cfg-if@1.0.1
	clang-sys@1.8.1
	cpufeatures@0.2.17
	crypto-common@0.1.6
	digest@0.10.7
	either@1.15.0
	generic-array@0.14.7
	glob@0.3.3
	hex@0.4.3
	itertools@0.13.0
	libc@0.2.175
	libloading@0.8.8
	log@0.4.27
	memchr@2.7.5
	minimal-lexical@0.2.1
	nom@7.1.3
	prettyplease@0.2.37
	proc-macro2@1.0.101
	quote@1.0.40
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-hash@2.1.1
	sha2@0.10.9
	shlex@1.3.0
	syn@2.0.106
	typenum@1.18.0
	unicode-ident@1.0.18
	version_check@0.9.5
	windows-link@0.1.3
	windows-targets@0.53.3
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.53.0
"

inherit pax-utils toolchain-funcs cargo

DESCRIPTION="World's fastest and most advanced password recovery utility"
HOMEPAGE="https://github.com/hashcat/hashcat"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hashcat/hashcat.git"
	SRC_URI="${CARGO_CRATE_URIS}"

else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/hashcat/hashcat/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="brain video_cards_nvidia"
RESTRICT=test

DEPEND="app-arch/lzma
	app-arch/unrar
	virtual/minizip:=
	brain? ( dev-libs/xxhash )
	video_cards_nvidia? (
		>x11-drivers/nvidia-drivers-440.64
		|| (
			dev-util/nvidia-cuda-toolkit
			virtual/opencl
		)
	)
	!video_cards_nvidia? ( virtual/opencl )"
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
	else
		default
	fi
	cargo_src_unpack
}

src_prepare() {
	# MAINTAINER NOTE: Hashcat's build system (src/bridges/*.mk) uses '|| true'
	# for Cargo calls. We strip these to make failures visible to emake.
	einfo "Forcing Cargo errors to be fatal..."
	sed -i 's/|| true//g' src/bridges/*.mk || die

	# upstream missed commit 96caad2 this before shipping 7.1.2 -- resolved in master
	sed -i 's|inc_checksum_crc\.cl|inc_checksum_crc32.cl|' OpenCL/m17220_a3-pure.cl || die

	# Remove bundled stuff
	rm -r deps/OpenCL-Headers || die "Failed to remove bundled OpenCL Headers"
	rm -r deps/xxHash || die "Failed to remove bundled xxHash"

	# TODO: Gentoo's app-arch/lzma doesn't install the needed files
	#rm -r deps/LZMA-SDK || die "Failed to remove bundled LZMA-SDK"
	#rm -r deps || die "Failed to remove bundled deps"

	# Do not strip
	sed -i "/LFLAGS                  += -s/d" src/Makefile || die

	# Do not add random CFLAGS
	sed -i "s/-O2//" src/Makefile || die

	#sed -i "#LZMA_SDK_INCLUDE#d" src/Makefile || die

	# Respect CC, CXX, AR
	sed -i \
		-e 's/:= gcc/:= $(CC)/' \
		-e 's/:= g++/:= $(CXX)/' \
		-e 's/:= ar/:= $(AR)/' \
		src/Makefile || die

	export PREFIX="${EPREFIX}"/usr
	export LIBRARY_FOLDER="/usr/$(get_libdir)"
	export DOCUMENT_FOLDER="/usr/share/doc/${PF}"

	default

	if [[ ${PV} == "9999" ]]; then
		local rust_projects=(
			"Rust/hashcat-sys"
			"Rust/bridges/dynamic_hash"
			"Rust/bridges/generic_hash"
		)
	else
		local rust_projects=(
			"Rust/generic_hash"
		)

	fi

	local proj
	for proj in "${rust_projects[@]}"; do
		if [[ -d "${S}/${proj}" ]]; then
			einfo "Configuring offline Cargo for: ${proj}"
			pushd "${S}/${proj}" > /dev/null || die
			cargo_gen_config
			popd > /dev/null || die
		fi
	done
}

src_compile() {
	tc-export CC CXX AR

	# Use bundled unrar for now, bug #792720
	emake \
		SHARED=1 \
		PRODUCTION=1 \
		ENABLE_BRAIN=$(usex brain 1 0) \
		USE_SYSTEM_LZMA=0 \
		USE_SYSTEM_OPENCL=1 \
		USE_SYSTEM_UNRAR=1 \
		USE_SYSTEM_ZLIB=1 \
		USE_SYSTEM_XXHASH=1 \
		VERSION_PURE="${PV}"

	pax-mark -mr hashcat || die "Failed to apply PaX markings"
}

src_test() {
	if use video_cards_nvidia; then
		addwrite /dev/nvidia0
		addwrite /dev/nvidiactl
		addwrite /dev/nvidia-uvm

		if [[ ! -w /dev/nvidia0 ]]; then
			einfo "To run these tests, portage likely must be in the video group."
			einfo "Please run \"gpasswd -a portage video\" if the tests will fail"
		fi
	fi

	# This always exits with 255 despite success
	#./hashcat -b -m 2500 || die "Test failed"
	LD_PRELOAD=./libhashcat.so.${PV} ./hashcat -a 3 -m 1500 nQCk49SiErOgk || die "Test failed"
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		SHARED=1 \
		PRODUCTION=1 \
		ENABLE_BRAIN=$(usex brain 1 0) \
		USE_SYSTEM_LZMA=0 \
		USE_SYSTEM_OPENCL=1 \
		USE_SYSTEM_UNRAR=1 \
		USE_SYSTEM_ZLIB=1 \
		USE_SYSTEM_XXHASH=1 \
		VERSION_PURE="${PV}" \
		install
}
