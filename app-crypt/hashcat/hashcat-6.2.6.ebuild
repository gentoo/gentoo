# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils toolchain-funcs

DESCRIPTION="World's fastest and most advanced password recovery utility"
HOMEPAGE="https://github.com/hashcat/hashcat"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hashcat/hashcat.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/hashcat/hashcat/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
IUSE="brain video_cards_nvidia"
RESTRICT=test

DEPEND="app-arch/lzma
	app-arch/unrar
	sys-libs/zlib[minizip]
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

src_prepare() {
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
		USE_SYSTEM_UNRAR=0 \
		USE_SYSTEM_ZLIB=1 \
		USE_SYSTEM_XXHASH=1 \
		VERSION_PURE="${PV}"

	pax-mark -mr hashcat
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
