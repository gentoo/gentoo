# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

KV_min=2.6.31

inherit autotools eutils multilib linux-info multilib-minimal

if [[ ${PV} = 9999* ]]
then
	EGIT_REPO_URI="git://github.com/gentoo/eudev.git"
	inherit git-2
else
	SRC_URI="https://dev.gentoo.org/~blueness/${PN}/${P}.tar.gz"
	KEYWORDS="ia64"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="https://github.com/gentoo/eudev"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="doc gudev hwdb kmod introspection keymap +modutils +openrc +rule-generator selinux static-libs test"

COMMON_DEPEND="gudev? ( dev-libs/glib:2 )
	kmod? ( sys-apps/kmod )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1 )
	selinux? ( sys-libs/libselinux )
	>=sys-apps/util-linux-2.20
	!<sys-libs/glibc-2.11
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r7
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

DEPEND="${COMMON_DEPEND}
	keymap? ( dev-util/gperf )
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	virtual/os-headers
	!<sys-kernel/linux-headers-${KV_min}
	doc? ( dev-util/gtk-doc )
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	test? ( app-text/tree dev-lang/perl )"

RDEPEND="${COMMON_DEPEND}
	!sys-fs/udev
	!sys-apps/coldplug
	!sys-apps/systemd
	!<sys-fs/lvm2-2.02.97
	!sys-fs/device-mapper
	!<sys-fs/udev-init-scripts-18
	gudev? ( !dev-libs/libgudev )"

PDEPEND="hwdb? ( >=sys-apps/hwids-20130717-r1[udev] )
	keymap? ( >=sys-apps/hwids-20130717-r1[udev] )
	openrc? ( >=sys-fs/udev-init-scripts-18 )"

REQUIRED_USE="keymap? ( hwdb )"

pkg_pretend()
{
	if ! use rule-generator; then
		ewarn
		ewarn "As of 2013-01-29, ${P} provides the new interface renaming functionality,"
		ewarn "as described in the URL below:"
		ewarn "http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames"
		ewarn
		ewarn "This functionality is enabled BY DEFAULT because eudev has no means of synchronizing"
		ewarn "between the default or user-modified choice of sys-fs/udev.  If you wish to disable"
		ewarn "this new iface naming, please be sure that /etc/udev/rules.d/80-net-name-slot.rules"
		ewarn "exists:"
		ewarn "\ttouch /etc/udev/rules.d/80-net-name-slot.rules"
		ewarn
		ewarn "We are working on a better solution for the next beta release."
		ewarn
	fi
}

pkg_setup()
{
	linux-info_pkg_setup
	get_running_version

	# These are required kernel options, but we don't error out on them
	# because you can build under one kernel and run under another.
	CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~SIGNALFD ~!SYSFS_DEPRECATED ~!SYSFS_DEPRECATED_V2"

	if kernel_is lt ${KV_min//./ }; then
		ewarn
		ewarn "Your current running kernel version ${KV_FULL} is too old to run ${P}."
		ewarn "Make sure to run udev under kernel version ${KV_min} or above."
		ewarn
	fi
}

src_prepare()
{
	# change rules back to group uucp instead of dialout for now
	sed -e 's/GROUP="dialout"/GROUP="uucp"/' -i rules/*.rules \
	|| die "failed to change group dialout to uucp"

	epatch "${FILESDIR}"/${PN}-selinux-timespan.patch

	epatch_user

	if [[ ! -e configure ]]
	then
		if use doc
		then
			gtkdocize --docdir docs || die "gtkdocize failed"
		else
			echo 'EXTRA_DIST =' > docs/gtk-doc.make
		fi
		eautoreconf
	else
		elibtoolize
	fi
}

multilib_src_configure()
{
	local econf_args

	econf_args=(
		ac_cv_search_cap_init=
		ac_cv_header_sys_capability_h=yes
		DBUS_CFLAGS=' '
		DBUS_LIBS=' '
		--with-rootprefix=
		--docdir=/usr/share/doc/${PF}
		--libdir=/usr/$(get_libdir)
		--with-firmware-path="${EPREFIX}usr/lib/firmware/updates:${EPREFIX}usr/lib/firmware:${EPREFIX}lib/firmware/updates:${EPREFIX}lib/firmware"
		--with-html-dir="/usr/share/doc/${PF}/html"
		--enable-split-usr
		--exec-prefix=/
	)

	# Only build libudev for non-native_abi, and only install it to libdir,
	# that means all options only apply to native_abi
	if multilib_is_native_abi; then econf_args+=(
		--with-rootlibdir=/$(get_libdir)
		$(use_enable doc gtk-doc)
		$(use_enable gudev)
		$(use_enable introspection)
		$(use_enable keymap)
		$(use_enable kmod libkmod)
		$(usex kmod --enable-modules $(use_enable modutils modules))
		$(use_enable static-libs static)
		$(use_enable selinux)
		$(use_enable rule-generator)
		)
	else econf_args+=(
		$(echo --disable-{gtk-doc,gudev,introspection,keymap,libkmod,modules,static,selinux,rule-generator})
		)
	fi
	ECONF_SOURCE="${S}" econf "${econf_args[@]}"
}

multilib_src_compile()
{
	if ! multilib_is_native_abi; then
		cd src/libudev || die "Could not change directory"
	fi
	emake
}

multilib_src_install()
{
	if ! multilib_is_native_abi; then
		cd src/libudev || die "Could not change directory"
	fi
	emake DESTDIR="${D}" install
}

multilib_src_test()
{
	# make sandbox get out of the way
	# these are safe because there is a fake root filesystem put in place,
	# but sandbox seems to evaluate the paths of the test i/o instead of the
	# paths of the actual i/o that results.
	# also only test for native abi
	if multilib_is_native_abi; then
		addread /sys
		addwrite /dev
		addwrite /run
		default_src_test
	fi
}

# disable header checks because we only install libudev headers for non-native abi
multilib_check_headers()
{
	:
}

multilib_src_install_all()
{
	prune_libtool_files --all
	rm -rf "${ED}"/usr/share/doc/${PF}/LICENSE.*

	use rule-generator && use openrc && doinitd "${FILESDIR}"/udev-postmount

	# drop distributed hwdb files, they override sys-apps/hwids
	rm -f "${ED}"/etc/udev/hwdb.d/*.hwdb
}

pkg_preinst()
{
	local htmldir
	for htmldir in gudev libudev; do
		if [[ -d ${EROOT}usr/share/gtk-doc/html/${htmldir} ]]
		then
			rm -rf "${EROOT}"usr/share/gtk-doc/html/${htmldir}
		fi
		if [[ -d ${ED}/usr/share/doc/${PF}/html/${htmldir} ]]
		then
			dosym ../../doc/${PF}/html/${htmldir} \
				/usr/share/gtk-doc/html/${htmldir}
		fi
	done
}

pkg_postinst()
{
	mkdir -p "${EROOT}"run

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${EROOT}"dev/loop 2>/dev/null
	if [[ -d ${EROOT}dev/loop ]]
	then
		ewarn "Please make sure you remove /dev/loop, else losetup"
		ewarn "may be confused when looking for unused devices."
	fi

	# 64-device-mapper.rules now gets installed by sys-fs/device-mapper
	# remove it if user don't has sys-fs/device-mapper installed, 27 Jun 2007
	if [[ -f ${EROOT}etc/udev/rules.d/64-device-mapper.rules ]] &&
		! has_version sys-fs/device-mapper
	then
		rm -f "${EROOT}"etc/udev/rules.d/64-device-mapper.rules
		einfo "Removed unneeded file 64-device-mapper.rules"
	fi

	if use hwdb && has_version 'sys-apps/hwids[udev]'; then
		udevadm hwdb --update --root="${ROOT%/}"

		# http://cgit.freedesktop.org/systemd/systemd/commit/?id=1fab57c209035f7e66198343074e9cee06718bda
		# reload database after it has be rebuilt, but only if we are not upgrading
		# also pass if we are -9999 since who knows what hwdb related changes there might be
		if [[ ${REPLACING_VERSIONS%-r*} == ${PV} || -z ${REPLACING_VERSIONS} ]] && \
		[[ ${ROOT%/} == "" ]] && [[ ${PV} != "9999" ]]; then
			udevadm control --reload
		fi
	fi

	ewarn
	ewarn "You need to restart eudev as soon as possible to make the"
	ewarn "upgrade go into effect:"
	ewarn "\t/etc/init.d/udev --nodeps restart"

	if use rule-generator && use openrc; then
		ewarn
		ewarn "Please add the udev-postmount init script to your default runlevel"
		ewarn "to ensure the legacy rule-generator functionality works as reliably"
		ewarn "as possible."
		ewarn "\trc-update add udev-postmount default"
	fi

	elog
	elog "For more information on eudev on Gentoo, writing udev rules, and"
	elog "fixing known issues visit:"
	elog "         https://www.gentoo.org/doc/en/udev-guide.xml"
	elog
}
