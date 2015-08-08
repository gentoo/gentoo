# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils multilib user

MY_P=${P/\./-}
MY_P=${MY_P/./-R}
S=${WORKDIR}

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://www.kismetwireless.net/${PN}.git"
	SRC_URI=""
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="http://www.kismetwireless.net/code/${MY_P}.tar.gz"
	KEYWORDS="amd64 arm ppc x86"
fi

DESCRIPTION="IEEE 802.11 wireless LAN sniffer"
HOMEPAGE="http://www.kismetwireless.net/"

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="+client +pcre speech +plugin-autowep +plugin-btscan plugin-dot15d4 +plugin-ptw +plugin-spectools +plugin-syslog +ruby selinux +suid"

CDEPEND="net-wireless/wireless-tools
	kernel_linux? ( sys-libs/libcap
			dev-libs/libnl:3
			net-libs/libpcap
			)
	pcre? ( dev-libs/libpcre )
	suid? ( sys-libs/libcap )
	client? ( sys-libs/ncurses )
	!arm? ( speech? ( app-accessibility/flite ) )
	ruby? ( dev-lang/ruby:* )
	plugin-btscan? ( net-wireless/bluez )
	plugin-dot15d4? ( virtual/libusb:0 )
	plugin-spectools? ( net-wireless/spectools )
"

DEPEND="${CDEPEND}
	virtual/pkgconfig
"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-kismet )
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	epatch "${FILESDIR}"/ruby19_fixes.patch
	epatch "${FILESDIR}"/update-kismet_shootout.patch
	mv configure.in configure.ac

	sed -i -e "s:^\(logtemplate\)=\(.*\):\1=/tmp/\2:" \
		conf/kismet.conf.in || die

	# Don't strip and set correct mangrp
	sed -i -e 's| -s||g' \
		-e 's|@mangrp@|root|g' Makefile.in || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable client) \
		$(use_enable pcre)
}

src_compile() {
	emake

	if use plugin-autowep; then
		cd "${S}"/restricted-plugin-autowep
		KIS_SRC_DIR="${S}" emake
	fi
	if use plugin-btscan; then
		cd "${S}"/plugin-btscan
		KIS_SRC_DIR="${S}" emake
	fi
	if use plugin-dot15d4; then
		cd "${S}"/plugin-dot15d4
		KIS_SRC_DIR="${S}" emake
	fi
	if use plugin-ptw; then
		cd "${S}"/restricted-plugin-ptw
		KIS_SRC_DIR="${S}" emake
	fi
	if use plugin-spectools; then
		cd "${S}"/plugin-spectools
		KIS_SRC_DIR="${S}" emake
	fi
	if use plugin-syslog; then
		cd "${S}"/plugin-syslog
		KIS_SRC_DIR="${S}" emake
	fi
}

src_install() {
	if use plugin-autowep; then
		cd "${S}"/restricted-plugin-autowep
		KIS_SRC_DIR="${S}" emake DESTDIR="${ED}" LIBDIR="$(get_libdir)" install
	fi
	if use plugin-btscan; then
		cd "${S}"/plugin-btscan
		KIS_SRC_DIR="${S}" emake DESTDIR="${ED}" LIBDIR="$(get_libdir)" install
	fi
	if use plugin-dot15d4; then
		cd "${S}"/plugin-dot15d4
		KIS_SRC_DIR="${S}" emake DESTDIR="${ED}" LIBDIR="$(get_libdir)" install
	fi
	if use plugin-ptw; then
		cd "${S}"/restricted-plugin-ptw
		KIS_SRC_DIR="${S}" emake DESTDIR="${ED}" LIBDIR="$(get_libdir)" install
	fi
	if use plugin-spectools; then
		cd "${S}"/plugin-spectools
		KIS_SRC_DIR="${S}" emake DESTDIR="${ED}" LIBDIR="$(get_libdir)" install
	fi
	if use plugin-syslog; then
		cd "${S}"/plugin-syslog
		KIS_SRC_DIR="${S}" emake DESTDIR="${ED}" LIBDIR="$(get_libdir)" install
	fi
	if use ruby; then
		cd "${S}"/ruby
		dobin *.rb
	fi

	cd "${S}"
	emake DESTDIR="${D}" commoninstall

	##dragorn would prefer I set fire to my head than do this, but it works
	##all external kismet plugins (read: kismet-ubertooth) must be rebuilt when kismet is
	##is there an automatic way to force this?
	# install headers for external plugins
	insinto /usr/include/kismet
	doins *.h
	doins Makefile.inc
	#todo write a plugin finder that tells you what needs to be rebuilt when kismet is updated, etc

	dodoc CHANGELOG RELEASENOTES.txt README* docs/DEVEL.client docs/README.newcore
	newinitd "${FILESDIR}"/${PN}.initd kismet
	newconfd "${FILESDIR}"/${PN}.confd kismet

	insinto /etc
	doins conf/kismet{,_drone}.conf

	if use suid; then
	dobin kismet_capture
	fi
}

pkg_preinst() {
	if use suid; then
		enewgroup kismet
		fowners root:kismet /usr/bin/kismet_capture
		# Need to set the permissions after chowning.
		# See chown(2)
		fperms 4550 /usr/bin/kismet_capture
		elog "Kismet has been installed with a setuid-root helper binary"
		elog "to enable minimal-root operation.  Users need to be part of"
		elog "the 'kismet' group to perform captures from physical devices."
	fi
	if ! use suid; then
		ewarn "It is highly discouraged to run a sniffer as root,"
		ewarn "Please consider enabling the suid use flag and adding"
		ewarn "your user to the kismet group."
	fi
}
