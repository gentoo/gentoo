# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vmware-vix/vmware-vix-1.11.4.744019.ebuild,v 1.2 2012/10/29 14:51:08 flameeyes Exp $

EAPI="4"

inherit eutils versionator vmware-bundle

MY_PN="VMware-VIX"
MY_PV="$(replace_version_separator 3 - $PV)"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="VMware VIX API for Linux"
HOMEPAGE="http://www.vmware.com/support/developer/vix-api/"
SRC_URI="
	x86? ( ${MY_P}.i386.bundle )
	amd64? ( ${MY_P}.x86_64.bundle )
	"

LICENSE="vmware"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="doc"
RESTRICT="fetch mirror strip"

# vmware-workstation should not use virtual/libc as this is a
# precompiled binary package thats linked to glibc.
RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	=dev-libs/openssl-0.9.8*
	net-misc/curl
	sys-libs/glibc
	sys-libs/zlib
	!app-emulation/vmware-workstation"

S=${WORKDIR}
VM_INSTALL_DIR="/opt/vmware"

pkg_nofetch() {
	local bundle

	if use x86; then
		bundle="${MY_P}.i386.bundle"
	elif use amd64; then
		bundle="${MY_P}.x86_64.bundle"
	fi

	einfo "Please download ${bundle}"
	einfo "from ${HOMEPAGE}"
	einfo "and place it in ${DISTDIR}"
}

src_unpack() {
	local component; for component in \
		vmware-vix \
		vmware-vix-core \
		vmware-vix-lib-Workstation800andvSphere500
		#vmware-vix-legacy \
	do
		vmware-bundle_extract-bundle-component "${DISTDIR}/${A}" "${component}" "${S}"
	done
}

src_install() {
	# install the binary
	into "${VM_INSTALL_DIR}"
	dobin bin/*

	# install the libraries
	insinto "${VM_INSTALL_DIR}"/lib/vmware-vix
	doins -r lib/*

	dosym vmware-vix/libvixAllProducts.so "${VM_INSTALL_DIR}"/lib/libbvixAllProducts.so

	# install headers
	insinto /usr/include/vmware-vix
	doins include/*

	if use doc; then
		dohtml -r doc/*
	fi

	# fix permissions
	fperms 0755 "${VM_INSTALL_DIR}"/lib/vmware-vix/setup/vmware-config

	# create the environment
	local envd="${T}/90${PN}"
	cat > "${envd}" <<-EOF
		PATH='${VM_INSTALL_DIR}/bin'
		ROOTPATH='${VM_INSTALL_DIR}/bin'
	EOF
	doenvd "${envd}"

	# create the configuration
	dodir /etc/vmware

	local vmconfig="${T}/config"
	if [[ -e ${ROOT}/etc/vmware/config ]]
	then
		cp -a "${ROOT}"/etc/vmware/config "${vmconfig}"
		sed -i -e "/vmware.fullpath/d" "${vmconfig}"
		sed -i -e "/vix.libdir/d" "${vmconfig}"
		sed -i -e "/vix.config.version/d" "${vmconfig}"
	fi

	cat >> "${vmconfig}" <<-EOF
		vmware.fullpath = "${VM_INSTALL_DIR}/bin/vmware"
		vix.libdir = "${VM_INSTALL_DIR}/lib/vmware-vix"
		vix.config.version = "1"
	EOF

	insinto /etc/vmware/
	doins "${vmconfig}"
}

pkg_postinst() {
	ewarn "/etc/env.d was updated. Please run:"
	ewarn "env-update && source /etc/profile"
}

pkg_prerm() {
	sed -i -e "/vix.libdir/d" "${ROOT}"/etc/vmware/config
}
