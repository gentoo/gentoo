# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

KV_min=2.6.39
WANT_AUTOMAKE=1.13

inherit autotools eutils linux-info multilib multilib-minimal user

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://github.com/gentoo/eudev.git"
	inherit git-2
else
	SRC_URI="https://dev.gentoo.org/~blueness/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 arm hppa ~mips ppc ppc64 x86"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="https://github.com/gentoo/eudev"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="doc gudev +hwdb +kmod introspection +keymap +modutils +openrc +rule-generator selinux static-libs test"

COMMON_DEPEND=">=sys-apps/util-linux-2.20
	gudev? ( >=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.38 )
	kmod? ( >=sys-apps/kmod-16 )
	selinux? ( >=sys-libs/libselinux-2.1.9 )
	!<sys-libs/glibc-2.11
	!sys-apps/gentoo-systemd-integration
	!sys-apps/systemd
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r7
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${COMMON_DEPEND}
	keymap? ( dev-util/gperf )
	virtual/os-headers
	virtual/pkgconfig
	>=sys-devel/make-3.82-r4
	>=sys-kernel/linux-headers-${KV_min}
	doc? ( >=dev-util/gtk-doc-1.18 )
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/intltool-0.50
	test? ( app-text/tree dev-lang/perl )"

RDEPEND="${COMMON_DEPEND}
	!<sys-fs/lvm2-2.02.103
	!<sec-policy/selinux-base-2.20120725-r10
	!sys-fs/udev
	!sys-apps/systemd
	gudev? ( !dev-libs/libgudev )"

PDEPEND="hwdb? ( >=sys-apps/hwids-20140304[udev] )
	keymap? ( >=sys-apps/hwids-20140304[udev] )
	openrc? ( >=sys-fs/udev-init-scripts-26 )"

REQUIRED_USE="keymap? ( hwdb )"

# The multilib-build.eclass doesn't handle situation where the installed headers
# are different in ABIs. In this case, we install libgudev headers in native
# ABI but not for non-native ABI.
multilib_check_headers() { :; }

pkg_pretend() {
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

pkg_setup() {
	CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~!SYSFS_DEPRECATED ~!SYSFS_DEPRECATED_V2 ~SIGNALFD ~EPOLL ~FHANDLE ~NET"
	linux-info_pkg_setup
	get_running_version

	# These are required kernel options, but we don't error out on them
	# because you can build under one kernel and run under another.
	if kernel_is lt ${KV_min//./ }; then
		ewarn
		ewarn "Your current running kernel version ${KV_FULL} is too old to run ${P}."
		ewarn "Make sure to run udev under kernel version ${KV_min} or above."
		ewarn
	fi
}

src_prepare() {
	# change rules back to group uucp instead of dialout for now
	sed -e 's/GROUP="dialout"/GROUP="uucp"/' -i rules/*.rules \
	|| die "failed to change group dialout to uucp"

	# Bug #520684
	epatch "${FILESDIR}"/${PN}-fix-selinux-headers.patch
	epatch "${FILESDIR}"/${PN}-fix-selinux-linking.patch

	epatch_user

	if use doc; then
		gtkdocize --docdir docs || die "gtkdocize failed"
	else
		echo 'EXTRA_DIST =' > docs/gtk-doc.make
	fi
	eautoreconf
}

multilib_src_configure() {
	tc-export CC #463846
	export cc_cv_CFLAGS__flto=no #502950

	# Keep sorted by ./configure --help and only pass --disable flags
	# when *required* to avoid external deps or unnecessary compile
	local econf_args
	econf_args=(
		ac_cv_search_cap_init=
		ac_cv_header_sys_capability_h=yes
		DBUS_CFLAGS=' '
		DBUS_LIBS=' '
		--with-rootprefix=
		--docdir=/usr/share/doc/${PF}
		--libdir=/usr/$(get_libdir)
		--with-rootlibexecdir=/lib/udev
		--with-firmware-path="${EPREFIX}usr/lib/firmware/updates:${EPREFIX}usr/lib/firmware:${EPREFIX}lib/firmware/updates:${EPREFIX}lib/firmware"
		--with-html-dir="/usr/share/doc/${PF}/html"
		--enable-split-usr
		--exec-prefix=/

		$(use_enable gudev)
	)

	# Only build libudev for non-native_abi, and only install it to libdir,
	# that means all options only apply to native_abi
	if multilib_is_native_abi; then
		econf_args+=(
			--with-rootlibdir=/$(get_libdir)
			$(use_enable doc gtk-doc)
			$(use_enable introspection)
			$(use_enable keymap)
			$(use_enable kmod libkmod)
			$(usex kmod --enable-modules $(use_enable modutils modules))
			$(use_enable static-libs static)
			$(use_enable selinux)
			$(use_enable rule-generator)
		)
	else
		econf_args+=(
			--disable-static
			--disable-gtk-doc
			--disable-introspection
			--disable-keymap
			--disable-libkmod
			--disable-modules
			--disable-selinux
			--disable-rule-generator
		)
	fi
	ECONF_SOURCE="${S}" econf "${econf_args[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		emake
	else
		emake -C src/shared
		emake -C src/libudev
		use gudev && emake -C src/gudev
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" install
	else
		emake -C src/libudev DESTDIR="${D}" install
		use gudev && emake -C src/gudev DESTDIR="${D}" install
	fi
}

multilib_src_test() {
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

multilib_src_install_all() {
	prune_libtool_files --all
	rm -rf "${ED}"/usr/share/doc/${PF}/LICENSE.*

	use rule-generator && use openrc && doinitd "${FILESDIR}"/udev-postmount

	# drop distributed hwdb files, they override sys-apps/hwids
	rm -f "${ED}"/etc/udev/hwdb.d/*.hwdb

	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/40-gentoo.rules

	insinto /usr/share/doc/${PF}/html/gudev
	doins "${S}"/docs/gudev/html/*

	insinto /usr/share/doc/${PF}/html/libudev
	doins "${S}"/docs/libudev/html/*
}

pkg_preinst() {
	local htmldir
	for htmldir in gudev libudev; do
		if [[ -d ${EROOT}usr/share/gtk-doc/html/${htmldir} ]]; then
			rm -rf "${EROOT}"usr/share/gtk-doc/html/${htmldir}
		fi
		if [[ -d ${ED}/usr/share/doc/${PF}/html/${htmldir} ]]; then
			dosym ../../doc/${PF}/html/${htmldir} \
				/usr/share/gtk-doc/html/${htmldir}
		fi
	done
}

pkg_postinst() {
	mkdir -p "${EROOT}"run

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${EROOT}"dev/loop 2>/dev/null
	if [[ -d ${EROOT}dev/loop ]]; then
		ewarn "Please make sure your remove /dev/loop,"
		ewarn "else losetup may be confused when looking for unused devices."
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

	if use rule-generator && use openrc && \
	[[ -x $(type -P rc-update) ]] && rc-update show | grep udev-postmount | grep -qsv 'boot\|default\|sysinit'; then
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

	# http://cgit.freedesktop.org/systemd/systemd/commit/rules/50-udev-default.rules?id=3dff3e00e044e2d53c76fa842b9a4759d4a50e69
	# https://bugs.gentoo.org/246847
	# https://bugs.gentoo.org/514174
	enewgroup input

	# Update hwdb database in case the format is changed by udev version.
	if has_version 'sys-apps/hwids[udev]'; then
		udevadm hwdb --update --root="${ROOT%/}"
		# Only reload when we are not upgrading to avoid potential race w/ incompatible hwdb.bin and the running udevd
		if [[ -z ${REPLACING_VERSIONS} ]]; then
			# http://cgit.freedesktop.org/systemd/systemd/commit/?id=1fab57c209035f7e66198343074e9cee06718bda
			if [[ ${ROOT} != "" ]] && [[ ${ROOT} != "/" ]]; then
				return 0
			fi
			udevadm control --reload
		fi
	fi
}
