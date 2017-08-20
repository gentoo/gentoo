# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit autotools distutils-r1 eutils linux-info perl-functions systemd user

MY_P=${P/_/}

DESCRIPTION="Access 1-Wire devices like a filesystem"
SRC_URI="mirror://sourceforge/owfs/${MY_P}.tar.gz"
HOMEPAGE="http://owfs.org/ https://sourceforge.net/projects/owfs/"

KEYWORDS="amd64 arm x86"
SLOT="0/4.0.0"
LICENSE="GPL-2"

RDEPEND="
	ftdi? ( dev-embedded/libftdi:0 )
	fuse? ( sys-fs/fuse )
	perl? ( dev-lang/perl:= )
	parport? ( sys-kernel/linux-headers )
	php? ( dev-lang/php:=[cli] )
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:0= )
	usb? ( virtual/libusb:0 )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )"

DEPEND="${RDEPEND}
	perl? ( dev-lang/swig )
	php? ( dev-lang/swig )
	python? ( dev-lang/swig )"

IUSE="debug ftdi ftpd fuse httpd parport perl php python tcl usb zeroconf"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1-vendordir.patch
	"${FILESDIR}"/${PN}-3.1p4-sysmacros.patch
)

S=${WORKDIR}/${MY_P}

OWUID=${OWUID:-owfs}
OWGID=${OWGID:-owfs}

pkg_setup() {
	if use kernel_linux; then
		linux-info_pkg_setup

		if linux_config_exists; then
			if ! linux_chkconfig_present W1; then
				ewarn "CONFIG_W1 isn't set. You will not be able to use 1-wire bus on this system!"
			fi
		else
			elog "Cannot find a linux kernel configuration. Continuing anyway."
		fi
	fi

	use perl && perl_set_version

	enewgroup ${OWGID} 150
	enewuser  ${OWUID} 150 -1 -1 ${OWGID}
}

src_prepare() {
	default

	# Support user's CFLAGS and LDFLAGS.
	sed -i "s/@CPPFLAGS@/@CPPFLAGS@ ${CFLAGS}/" \
		module/swig/perl5/OW/Makefile.linux.in || die
	sed -i "s/@LIBS@/@LIBS@ ${LDFLAGS}/" \
		module/swig/perl5/OW/Makefile.linux.in || die

	eautoreconf
}

src_configure() {
	# disable owpython since we can build python anyway
	# and without it, we don't have to fix the build ;)
	local myeconf=(
		$(use_enable debug)
		$(use_enable fuse owfs)
		$(use_enable ftdi)
		$(use_enable ftpd owftpd)
		$(use_enable httpd owhttpd)
		$(use_enable parport)
		$(use_enable perl owperl)
		$(use_enable php owphp)
		--disable-owpython
		$(use_enable tcl owtcl)
		$(use_enable zeroconf avahi)
		$(use_enable zeroconf zero)
		$(use_enable usb)
		--with-systemdsystemunitdir=$(systemd_get_systemunitdir)
	)

	if use httpd || use ftpd || use fuse; then
		myeconf+=( --enable-owserver )
	else
		myeconf+=( --disable-owserver )
	fi

	econf ${myeconf[@]}
}

src_compile() {
	default

	if use python; then
		local CFLAGS="${CFLAGS} -fno-strict-aliasing"

		pushd module/ownet/python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die

		pushd module/swig/python > /dev/null || die
		emake ow_wrap.c
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_test() { :; }

src_install() {
	default

	if use httpd || use ftpd || use fuse; then
		newinitd "${FILESDIR}"/owserver.initd-r1 owserver
		newconfd "${FILESDIR}"/owserver.confd owserver

		for i in httpd ftpd; do
			if use ${i}; then
				newinitd "${FILESDIR}"/ow${i}.initd-r1 ow${i}
				newconfd "${FILESDIR}"/ow${i}.confd ow${i}
			fi
		done

		if use fuse; then
			dodir /var/lib/owfs
			dodir /var/lib/owfs/mnt
			newinitd "${FILESDIR}"/owfs.initd-r1 owfs
			newconfd "${FILESDIR}"/owfs.confd owfs
		fi
	fi

	use perl && perl_delete_localpod

	if use python; then
		pushd module/ownet/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die

		pushd module/swig/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi

	prune_libtool_files
}

pkg_postinst() {
	if use httpd || use ftpd || use fuse; then
		echo
		if [[ ${OWUID} != root ]]; then
			ewarn
			ewarn "In order to allow the OWFS daemon user '${OWUID}' to read"
			ewarn "from and/or write to a 1 wire bus controller device, make"
			ewarn "sure the user has appropriate permission to access the"
			ewarn "corresponding device node/path (e.g. /dev/ttyS0), for example"
			ewarn "by adding the user to the group 'uucp' (for serial devices)"
			ewarn "or 'usb' (for USB devices accessed via usbfs on /proc/bus/usb),"
			ewarn "or install an appropriate UDEV rules (see http://owfs.org/index.php?page=udev-and-usb"
			ewarn "for more information)."
			ewarn
			if use fuse; then
				ewarn "In order to allow regular users to read from and/or write to"
				ewarn "1 wire bus devices accessible via the owfs FUSE filesystem"
				ewarn "client and its filesystem mountpoint, make sure the user is"
				ewarn "a member of the group '${OWGID}'."
				ewarn
			fi
			echo
		fi
	fi
}
