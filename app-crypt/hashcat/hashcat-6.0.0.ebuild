# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils pax-utils multilib

DESCRIPTION="World's fastest and most advanced password recovery utility"
HOMEPAGE="https://github.com/hashcat/hashcat"
LICENSE="MIT"
SLOT="0"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hashcat/hashcat.git"
else
	#this doesn't work for me, so it doesn't get keywords
	#KEYWORDS="~amd64"
	SRC_URI="https://github.com/hashcat/hashcat/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

IUSE="brain video_cards_nvidia"
DEPEND="virtual/opencl
	app-arch/lzma
	brain? ( dev-libs/xxhash )
	video_cards_nvidia? ( >x11-drivers/nvidia-drivers-367.0 )"
RDEPEND="${DEPEND}"

src_prepare() {
	#remove bundled stuff
	rm -r deps/OpenCL-Headers || die "Failed to remove bundled OpenCL Headers"
	rm -r deps/xxHash || die "Failed to remove bundled xxHash"
	#rm -r deps/LZMA-SDK || die "Failed to remove bundled LZMA-SDK"
	#rm -r deps || die "Failed to remove bundled deps"
	#do not strip
	sed -i "/LFLAGS                  += -s/d" src/Makefile
	#do not add random CFLAGS
	sed -i "s/-O2//" src/Makefile || die
	sed -i "#LZMA_SDK_INCLUDE#d" src/Makefile || die
	export PREFIX=/usr
	export LIBRARY_FOLDER="/usr/$(get_libdir)"
	export DOCUMENT_FOLDER="/usr/share/doc/${P}"
	eapply_user
}

src_compile() {
	emake SHARED=1 PRODUCTION=1 ENABLE_BRAIN=$(usex brain 1 0) USE_SYSTEM_LZMA=0 USE_SYSTEM_OPENCL=1 USE_SYSTEM_XXHASH=1 VERSION_PURE="${PV}"
	pax-mark -mr hashcat
}

src_test() {
	if use video_cards_nvidia; then
		addwrite /dev/nvidia0
		addwrite /dev/nvidiactl
		addwrite /dev/nvidia-uvm
		if [ ! -w /dev/nvidia0 ]; then
			einfo "To run these tests, portage likely must be in the video group."
			einfo "Please run \"gpasswd -a portage video\" if the tests will fail"
		fi
	#elif use vidia_cards_fglrx; then
	#	addwrite /dev/ati
	fi
	#this always exits with 255 despite success
	#./hashcat -b -m 2500 || die "Test failed"
	LD_PRELOAD=./libhashcat.so.${PV} ./hashcat -a 3 -m 1500 nQCk49SiErOgk || die "Test failed"
}

src_install() {
	emake DESTDIR="${ED}" SHARED=1 PRODUCTION=1 ENABLE_BRAIN=$(usex brain 1 0) USE_SYSTEM_LZMA=0 USE_SYSTEM_OPENCL=1 USE_SYSTEM_XXHASH=1 VERSION_PURE="${PV}" install
}
