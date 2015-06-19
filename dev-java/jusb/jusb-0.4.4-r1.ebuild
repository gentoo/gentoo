# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jusb/jusb-0.4.4-r1.ebuild,v 1.4 2011/11/25 02:01:58 robbat2 Exp $

inherit eutils java-pkg-2 linux-info flag-o-matic multilib

DESCRIPTION="jUSB provides a Free Software Java API for USB"
HOMEPAGE="http://jusb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.4
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}

CONFIG_CHECK="~USB_DEVICEFS"

ERROR_CONFIG_USB_DEVICEFS="
You need to turn on the USB device filesystem
option under USB support in order to use jUSB
"

pkg_setup() {
	linux-info_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${A}

	mkdir src
	tar -xzf src.tgz -C src

	# The struct usbdevfs_ctrltransfer is different
	# in latest 2.4 and 2.6 kernels. This patch is
	# to make jusb compile on 2.6 kernels
	! kernel_is 2 4 && epatch ${FILESDIR}/${P}-native.patch

	epatch ${FILESDIR}/${P}-makefile.patch

	sed -i \
		-e 's#-shared#-shared -Wl,-soname=libjusb.so#' \
		-e 's#javac#javac $(JAVACFLAGS)#' \
		"${S}/Makefile" || die "sed failed"
}

src_compile() {
	export OSTYPE="linux-gnu"

	# makefile patching isnt worth the trouble, only
	# one native source file
	append-flags -fPIC

	# bug #279088
	emake -j1 || die "Failed to compile"
	use doc && make javadoc
}

src_install() {
	java-pkg_dojar jusb.jar
	java-pkg_sointo /usr/$(get_libdir)
	java-pkg_doso libjusb.so

	dodoc README*

	if use doc; then
		java-pkg_dohtml doc/*.html
		java-pkg_dohtml -r apidoc/*
	fi
	use source && java-pkg_dosrc src/*
}
