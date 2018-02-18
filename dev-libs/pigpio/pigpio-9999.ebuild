# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit git-r3 distutils-r1

DESCRIPTION="pigpio is a library for the Raspberry which allows control of the General Purpose Input Outputs (GPIO)."
HOMEPAGE="http://abyz.me.uk/rpi/pigpio/index.html"
EGIT_REPO_URI="https://github.com/joan2937/pigpio/"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~arm"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eapply "${FILESDIR}/${P}-sysmacros.patch"
	eapply "${FILESDIR}/${P}-makefile.patch"
	eapply_user
}

src_compile() {
	emake
	if use python ; then
		distutils-r1_src_compile
	fi
}

src_install() {
	dolib.so libpigpio.so.0
	dolib.so libpigpiod_if.so.0
	dolib.so libpigpiod_if2.so.0
	dosym libpigpio.so.0 /usr/$(get_libdir)/libpigpio.so
	dosym libpigpiod_if.so.0 /usr/$(get_libdir)/libpigpiod_if.so
	dosym libpigpiod_if2.so.0 /usr/$(get_libdir)/libpigpiod_if2.so
	dobin pigpiod
	dobin pig2vcd
	dobin pigs
	doman *.1
	doman *.3
	newinitd "${FILESDIR}"/pigpiod.initd pigpiod
	newconfd "${FILESDIR}"/pigpiod.confd pigpiod
	if use python ; then
		distutils-r1_src_install
	fi
}

