# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils pax-utils multilib

DESCRIPTION="World's fastest and most advanced password recovery utility"
HOMEPAGE="https://github.com/hashcat/hashcat"
SRC_URI="https://github.com/hashcat/hashcat/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="video_cards_nvidia"
DEPEND="virtual/opencl
	video_cards_nvidia? ( >x11-drivers/nvidia-drivers-367.0 )"
RDEPEND="${DEPEND}"

src_prepare() {
	#do not strip
	sed -i "/LFLAGS                  += -s/d" src/Makefile
	#do not add random CFLAGS
	sed -i "s/-O2//" src/Makefile || die
	export PREFIX=/usr
	export LIBRARY_FOLDER="/usr/$(get_libdir)"
	export DOCUMENT_FOLDER="/usr/share/doc/${P}"
	eapply_user
}

src_compile() {
	default
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
	./hashcat -a 3 -m 1500 nQCk49SiErOgk || die "Test failed"
}
