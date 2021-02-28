# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
PYTHON_REQ_USE="threads(+),xml"

# 14 and 15 spit out a lot of warnings about subdirs
WANT_AUTOMAKE="1.13"

inherit autotools linux-info python-single-r1 readme.gentoo-r1 udev

DESCRIPTION="HP Linux Imaging and Printing - Print, scan, fax drivers and service tools"
HOMEPAGE="https://developers.hp.com/hp-linux-imaging-and-printing"
SRC_URI="mirror://sourceforge/hplip/${P}.tar.gz
		https://dev.gentoo.org/~billie/distfiles/${PN}-3.20.11-patches-2.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"

IUSE="doc fax +hpcups hpijs kde libnotify libressl -libusb0 minimal parport policykit qt5 scanner +snmp static-ppds X"

COMMON_DEPEND="
	net-print/cups
	sys-apps/dbus
	virtual/jpeg:0
	hpijs? ( net-print/cups-filters[foomatic] )
	!libusb0? ( virtual/libusb:1 )
	libusb0? ( virtual/libusb:0 )
	${PYTHON_DEPS}
	!minimal? (
		scanner? (
			media-gfx/sane-backends
		)
		snmp? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:= )
			net-analyzer/net-snmp:=
			$(python_gen_cond_dep 'net-dns/avahi[dbus,${PYTHON_MULTI_USEDEP}]')
		)
	)
"
BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="
	${COMMON_DEPEND}
	app-text/ghostscript-gpl
	!minimal? (
		$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]' 'python3*')
		kernel_linux? ( virtual/udev )
		$(python_gen_cond_dep '
			>=dev-python/dbus-python-1.2.0-r1[${PYTHON_MULTI_USEDEP}]
			dev-python/distro[${PYTHON_MULTI_USEDEP}]
			fax? ( dev-python/reportlab[${PYTHON_MULTI_USEDEP}] )
			qt5? (
				>=dev-python/PyQt5-5.5.1[dbus,gui,widgets,${PYTHON_MULTI_USEDEP}]
				libnotify? ( dev-python/notify2[${PYTHON_MULTI_USEDEP}] )
			)
			scanner? (
				>=dev-python/reportlab-3.2[${PYTHON_MULTI_USEDEP}]
				>=dev-python/pillow-3.1.1[${PYTHON_MULTI_USEDEP}]
				X? (
					|| (
						kde? ( kde-misc/skanlite )
						media-gfx/xsane
						media-gfx/sane-frontends
					)
				)
			)
		')
	)
	policykit? ( sys-auth/polkit )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${WORKDIR}/patches"
)

CONFIG_CHECK="~PARPORT ~PPDEV"
ERROR_PARPORT="Please make sure kernel parallel port support is enabled (PARPORT and PPDEV)."

#DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
For more information on setting up your printer please take
a look at the hplip section of the gentoo printing guide:
https://wiki.gentoo.org/wiki/Printing
"

pkg_setup() {
	python-single-r1_pkg_setup

	use scanner && ! use X && ewarn "You need USE=X for the scanner GUI."

	use parport && linux-info_pkg_setup

	if use minimal ; then
		ewarn "Installing driver portions only, make sure you know what you are doing."
		ewarn "Depending on the USE flags set for hpcups or hpijs the appropiate driver"
		ewarn "is installed. If both USE flags are set hpijs overrides hpcups."
		ewarn "This also disables fax, network, scanner and gui support!"
	fi

	if ! use hpcups && ! use hpijs ; then
		ewarn "Installing neither hpcups (USE=-hpcups) nor hpijs (USE=-hpijs) driver,"
		ewarn "which is probably not what you want."
		ewarn "You will almost certainly not be able to print."
	fi
}

src_prepare() {
	default

	python_fix_shebang .

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

	eautoreconf
}

src_configure() {
	local drv_build minimal_build

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
		minimal_build="${minimal_build} --disable-fax-build"
		minimal_build="${minimal_build} --disable-network-build"
		minimal_build="${minimal_build} --disable-scan-build"
		minimal_build="${minimal_build} --disable-gui-build"
	else
		if use fax ; then
			minimal_build="${minimal_build} --enable-fax-build"
		else
			minimal_build="${minimal_build} --disable-fax-build"
		fi
		if use snmp ; then
			minimal_build="${minimal_build} --enable-network-build"
		else
			minimal_build="${minimal_build} --disable-network-build"
		fi
		if use scanner ; then
			minimal_build="${minimal_build} --enable-scan-build"
		else
			minimal_build="${minimal_build} --disable-scan-build"
		fi
		if use qt5 ; then
			minimal_build="${minimal_build} --enable-qt5"
			minimal_build="${minimal_build} --enable-gui-build"
		else
			minimal_build="${minimal_build} --disable-gui-build"
			minimal_build="${minimal_build} --disable-qt5"
		fi
	fi

	# disable class driver for now
	econf \
		--disable-class-driver \
		--disable-foomatic-rip-hplip-install \
		--disable-cups11-build \
		--disable-lite-build \
		--disable-shadow-build \
		--disable-qt3 \
		--disable-qt4 \
		--disable-udev_sysfs_rules \
		--with-cupsbackenddir=$(cups-config --serverbin)/backend \
		--with-cupsfilterdir=$(cups-config --serverbin)/filter \
		--with-docdir=/usr/share/doc/${PF} \
		--with-htmldir=/usr/share/doc/${PF}/html \
		--enable-hpps-install \
		--enable-dbus-build \
		${drv_build} \
		${minimal_build} \
		$(use_enable doc doc-build) \
		$(use_enable libusb0 libusb01_build) \
		$(use_enable parport pp-build) \
		$(use_enable policykit)

	# hpijs ppds are created at configure time but are not installed (3.17.11)

	# Use system foomatic-rip for hpijs driver instead of foomatic-rip-hplip
	# The hpcups driver does not use foomatic-rip
	#local i
	#for i in ppd/hpijs/*.ppd.gz ; do
	#	rm -f ${i}.temp || die
	#	gunzip -c ${i} | sed 's/foomatic-rip-hplip/foomatic-rip/g' | \
	#		gzip > ${i}.temp || die
	#	mv ${i}.temp ${i} || die
	#done
}

src_install() {
	# Disable parallel install
	# Gentoo Bug: https://bugs.gentoo.org/show_bug.cgi?id=578018
	emake -j1 DESTDIR="${D}" install
	einstalldocs
	# default

	# Installed by sane-backends
	# Gentoo Bug: https://bugs.gentoo.org/show_bug.cgi?id=201023
	rm -f "${ED}"/etc/sane.d/dll.conf || die

	# Remove desktop and autostart files
	# Gentoo Bug: https://bugs.gentoo.org/show_bug.cgi?id=638770
	use qt5 || {
		rm -Rf "${ED}"/usr/share/applications "${ED}"/etc/xdg
	}

	rm -f "${ED}"/usr/share/doc/${PF}/{copyright,README_LIBJPG,COPYING} || die
	rmdir --ignore-fail-on-non-empty "${ED}"/usr/share/doc/${PF}/ || die

	# Remove hal fdi files
	rm -rf "${ED}"/usr/share/hal || die

	find "${D}" -name '*.la' -delete || die

	python_optimize "${ED}"/usr/share/hplip

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
