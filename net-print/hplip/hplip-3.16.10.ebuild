# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_REQ_USE="threads,xml"

inherit eutils linux-info python-single-r1 readme.gentoo-r1 udev autotools

DESCRIPTION="HP Linux Imaging and Printing - Print, scan, fax drivers and service tools"
HOMEPAGE="http://hplipopensource.com/hplip-web/index.html"
SRC_URI="mirror://sourceforge/hplip/${P}.tar.gz
		https://dev.gentoo.org/~billie/distfiles/${PN}-3.16.5-patches-1.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

IUSE="doc fax +hpcups hpijs kde -libusb0 minimal parport policykit +qt4 qt5 scanner +snmp static-ppds X"

# dependency on dev-python/notify-python dropped due to python 3 incompatibility
# possible replacement notify2 (https://pypi.python.org/pypi/notify2/0.3) not in tree

COMMON_DEPEND="
	virtual/jpeg:0
	hpijs? (
		|| ( >=net-print/cups-filters-1.0.43-r1[foomatic] >=net-print/foomatic-filters-3.0.20080507[cups] )
	)
	>=net-print/cups-1.4.0
	!minimal? (
		${PYTHON_DEPS}
		!libusb0? ( virtual/libusb:1 )
		libusb0? ( virtual/libusb:0 )
		scanner? ( >=media-gfx/sane-backends-1.0.19-r1 )
		fax? ( >=sys-apps/dbus-1.6.8-r1 )
		snmp? (
			net-analyzer/net-snmp
			dev-libs/openssl:0
		)
	)"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

RDEPEND="${COMMON_DEPEND}
	>=app-text/ghostscript-gpl-8.71-r3
	policykit? ( sys-auth/polkit )
	!minimal? (
		>=dev-python/dbus-python-1.2.0-r1[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		kernel_linux? ( virtual/udev )
		scanner? (
			>=dev-python/reportlab-3.1.44-r2[${PYTHON_USEDEP}]
			>=dev-python/pillow-3.1.1[${PYTHON_USEDEP}]
			X? ( || (
				kde? ( kde-misc/skanlite )
				media-gfx/xsane
				media-gfx/sane-frontends
			) )
		)
		fax? ( >=dev-python/reportlab-3.1.44-r2[${PYTHON_USEDEP}] )
		qt4? ( >=dev-python/PyQt4-4.11.1[dbus,X,${PYTHON_USEDEP}] )
		qt5? ( >=dev-python/PyQt5-5.5.1[dbus,gui,${PYTHON_USEDEP}] )
	)"

REQUIRED_USE="
	!minimal? ( ${PYTHON_REQUIRED_USE} )
	!minimal? ( qt4? ( !qt5 ) )
"

CONFIG_CHECK="~PARPORT ~PPDEV"
ERROR_PARPORT="Please make sure kernel parallel port support is enabled (PARPORT and PPDEV)."

#DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
For more information on setting up your printer please take
a look at the hplip section of the gentoo printing guide:
https://wiki.gentoo.org/wiki/Printing

Any user who wants to print must be in the lp group.
"

pkg_setup() {
	use !minimal && python-single-r1_pkg_setup

	! use qt4 && ! use qt5 && ewarn "You need USE=qt4 or USE=qt5 for the hplip GUI."

	use scanner && ! use X && ewarn "You need USE=X for the scanner GUI."

	if ! use hpcups && ! use hpijs ; then
		ewarn "Installing neither hpcups (USE=-hpcups) nor hpijs (USE=-hpijs) driver,"
		ewarn "which is probably not what you want."
		ewarn "You will almost certainly not be able to print."
	fi

	if use minimal ; then
		ewarn "Installing driver portions only, make sure you know what you are doing."
		ewarn "Depending on the USE flags set for hpcups or hpijs the appropiate driver"
		ewarn "is installed. If both USE flags are set hpijs overrides hpcups."
	else
		use parport && linux-info_pkg_setup
	fi
}

src_prepare() {
	eapply "${WORKDIR}/patches"
	eapply "${FILESDIR}/${PN}-3.16.9-hpps-indent.patch"

	default

	if use !minimal ; then
		python_export EPYTHON PYTHON
		python_fix_shebang .
	fi

	# Make desktop files follow the specification
	# Gentoo bug: https://bugs.gentoo.org/show_bug.cgi?id=443680
	# Upstream bug: https://bugs.launchpad.net/hplip/+bug/1080324
	sed -i -e '/^Categories=/s/Application;//' \
		-e '/^Encoding=.*/d' hplip.desktop.in || die
	sed -i -e '/^Categories=/s/Application;//' \
		-e '/^Version=.*/d' \
		-e '/^Comment=.*/d' hplip-systray.desktop.in || die

	# Fix for Gentoo bug https://bugs.gentoo.org/show_bug.cgi?id=345725
	# Upstream bug: https://bugs.launchpad.net/hplip/+bug/880847,
	# https://bugs.launchpad.net/hplip/+bug/500086
	local udevdir=$(get_udevdir)
	sed -i -e "s|/etc/udev|${udevdir}|g" \
		$(find . -type f -exec grep -l /etc/udev {} +) || die

	# Force recognition of Gentoo distro by hp-check
	sed -i \
		-e "s:file('/etc/issue', 'r').read():'Gentoo':" \
		installer/core_install.py || die

	# Use system foomatic-rip for hpijs driver instead of foomatic-rip-hplip
	# The hpcups driver does not use foomatic-rip
	local i
	for i in ppd/hpijs/*.ppd.gz ; do
		rm -f ${i}.temp || die
		gunzip -c ${i} | sed 's/foomatic-rip-hplip/foomatic-rip/g' | \
			gzip > ${i}.temp || die
		mv ${i}.temp ${i} || die
	done

	eautoreconf
}

src_configure() {
	local myconf drv_build minimal_build

	if use qt4 || use qt5 ; then
		myconf="${myconf} --enable-gui-build"
	else
		myconf="${myconf} --disable-gui-build"
	fi

	if use fax ||  use qt4 || use qt5 ; then
		myconf="${myconf} --enable-dbus-build"
	else
		myconf="${myconf} --disable-dbus-build"
	fi

	if use libusb0 ; then
		myconf="${myconf} --enable-libusb01_build"
	else
		myconf="${myconf} --disable-libusb01_build"
	fi

	if use hpcups ; then
		drv_build="$(use_enable hpcups hpcups-install)"
		if use static-ppds ; then
			drv_build="${drv_build} --enable-cups-ppd-install"
			drv_build="${drv_build} --disable-cups-drv-install"
		else
			drv_build="${drv_build} --enable-cups-drv-install"
			drv_build="${drv_build} --disable-cups-ppd-install"
		fi
	else
		drv_build="--disable-hpcups-install"
		drv_build="${drv_build} --disable-cups-drv-install"
		drv_build="${drv_build} --disable-cups-ppd-install"
	fi

	if use hpijs ; then
		drv_build="${drv_build} $(use_enable hpijs hpijs-install)"
		if use static-ppds ; then
			drv_build="${drv_build} --enable-foomatic-ppd-install"
			drv_build="${drv_build} --disable-foomatic-drv-install"
		else
			drv_build="${drv_build} --enable-foomatic-drv-install"
			drv_build="${drv_build} --disable-foomatic-ppd-install"
		fi
	else
		drv_build="${drv_build} --disable-hpijs-install"
		drv_build="${drv_build} --disable-foomatic-drv-install"
		drv_build="${drv_build} --disable-foomatic-ppd-install"
	fi

	if use minimal ; then
		if use hpijs ; then
			minimal_build="--enable-hpijs-only-build"
		else
			minimal_build="--disable-hpijs-only-build"
		fi
		if use hpcups ; then
			minimal_build="${minimal_build} --enable-hpcups-only-build"
		else
			minimal_build="${minimal_build} --disable-hpcups-only-build"
		fi
	fi

	econf \
		--disable-cups11-build \
		--disable-lite-build \
		--disable-foomatic-rip-hplip-install \
		--disable-shadow-build \
		--disable-qt3 \
		--disable-udev_sysfs_rules \
		--with-cupsbackenddir=$(cups-config --serverbin)/backend \
		--with-cupsfilterdir=$(cups-config --serverbin)/filter \
		--with-docdir=/usr/share/doc/${PF} \
		--with-htmldir=/usr/share/doc/${PF}/html \
		${myconf} \
		${drv_build} \
		${minimal_build} \
		$(use_enable doc doc-build) \
		$(use_enable fax fax-build) \
		$(use_enable parport pp-build) \
		$(use_enable scanner scan-build) \
		$(use_enable snmp network-build) \
		$(use_enable qt4) \
		$(use_enable qt5) \
		$(use_enable policykit)
}

src_install() {
	# disable parallel install
	# Gentoo Bug: https://bugs.gentoo.org/show_bug.cgi?id=578018
	emake -j1 DESTDIR="${D}" install
	einstalldocs
	# default

	# Installed by sane-backends
	# Gentoo Bug: https://bugs.gentoo.org/show_bug.cgi?id=201023
	rm -f "${D}"/etc/sane.d/dll.conf || die

	rm -f "${D}"/usr/share/doc/${PF}/{copyright,README_LIBJPG,COPYING} || die
	rmdir --ignore-fail-on-non-empty "${D}"/usr/share/doc/${PF}/ || die

	# Remove hal fdi files
	rm -rf "${D}"/usr/share/hal || die

	prune_libtool_files --all

	if use !minimal ; then
		python_export EPYTHON PYTHON
		python_optimize "${D}"/usr/share/hplip
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
