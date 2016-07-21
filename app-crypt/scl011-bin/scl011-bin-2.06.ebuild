# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib toolchain-funcs udev

DESCRIPTION="pcsc-lite driver for the German identification card (nPA)"
HOMEPAGE="http://www.scmmicro.com/de/products-services/chipkartenleser-terminals/kontaktlos-dual-interface/it-sicherheitskit-basisleser/treiber.html"
SRC_URI="x86? ( http://www.scmmicro.com/npa/files/scl011_${PV}_linux_32bit.tar.gz )
	amd64? ( http://www.scmmicro.com/npa/files/scl011_${PV}_linux_64bit.tar.gz )"

LICENSE="SCM-MICRO"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="sys-apps/pcsc-lite"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"

RESTRICT="mirror bindist"

QA_PREBUILT="*/libSCL011.so.2.06"

src_install() {
	local INSTALL_DIR=`$(tc-getPKG_CONFIG) libpcsclite --variable=usbdropdir`
	local BASEPATH
	case $(tc-arch) in
		amd64) BASEPATH="${S}/scl011_${PV}_linux_64bit" ;;
		x86)   BASEPATH="${S}/scl011_${PV}_linux_32bit" ;;
	esac

	insinto "${INSTALL_DIR}"/SCL011.bundle/Contents
	doins "${BASEPATH}"/proprietary/SCL011.bundle/Contents/Info.plist
	exeinto "${INSTALL_DIR}"/SCL011.bundle/Contents/Linux
	doexe "${BASEPATH}"/proprietary/SCL011.bundle/Contents/Linux/libSCL011.so.${PV}

	udev_dorules "${FILESDIR}"/92_pcscd_scl011-bin.rules
}
