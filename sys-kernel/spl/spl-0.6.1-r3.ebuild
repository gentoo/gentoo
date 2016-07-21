# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
AUTOTOOLS_AUTORECONF="1"

inherit flag-o-matic linux-info linux-mod autotools-utils

if [[ ${PV} == "9999" ]] ; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/zfsonlinux/${PN}.git"
else
	inherit eutils versionator
	MY_PV=$(replace_version_separator 3 '-')
	SRC_URI="https://github.com/zfsonlinux/${PN}/archive/${PN}-${MY_PV}.tar.gz"
	S="${WORKDIR}/${PN}-${PN}-${MY_PV}"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
fi

DESCRIPTION="The Solaris Porting Layer is a Linux kernel module which provides many of the Solaris kernel APIs"
HOMEPAGE="http://zfsonlinux.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="custom-cflags debug debug-log"
RESTRICT="test"

COMMON_DEPEND="dev-lang/perl
	virtual/awk"

DEPEND="${COMMON_DEPEND}"

RDEPEND="${COMMON_DEPEND}
	!sys-devel/spl"

AT_M4DIR="config"
AUTOTOOLS_IN_SOURCE_BUILD="1"

pkg_setup() {
	linux-info_pkg_setup
	CONFIG_CHECK="
		!DEBUG_LOCK_ALLOC
		!GRKERNSEC_HIDESYM
		MODULES
		KALLSYMS
		!PAX_KERNEXEC_PLUGIN_METHOD_OR
		!UIDGID_STRICT_TYPE_CHECKS
		ZLIB_DEFLATE
		ZLIB_INFLATE
	"

	kernel_is ge 2 6 26 || die "Linux 2.6.26 or newer required"

	[ ${PV} != "9999" ] && \
		{ kernel_is le 3 10 || die "Linux 3.10 is the latest supported version."; }

	check_extra_config
}

src_prepare() {
	# Workaround for hard coded path
	sed -i "s|/sbin/lsmod|/bin/lsmod|" scripts/check.sh || die

	if [ ${PV} != "9999" ]
	then
		# Be more like FreeBSD and Illumos when handling hostids
		epatch "${FILESDIR}/${PN}-0.6.0_rc14-simplify-hostid-logic.patch"

		# Block tasks properly
		epatch "${FILESDIR}/${PN}-0.6.1-fix-delay.patch"

		# Linux 3.10 Compatibility
		epatch "${FILESDIR}/${PN}-0.6.1-linux-3.10-compat.patch"

		# Fix kernel builtin support
		epatch "${FILESDIR}/${PN}-0.6.1-builtin-fix.patch"

		# Support recent hardened kernels
		if kernel_is ge 3 8
		then
			epatch "${FILESDIR}/${PN}-0.6.1-constify-ctl_table.patch"
		fi
	fi

	# splat is unnecessary unless we are debugging
	use debug || { sed -e 's/^subdir-m += splat$//' -i "${S}/module/Makefile.in" || die ; }

	autotools-utils_src_prepare
}

src_configure() {
	use custom-cflags || strip-flags
	filter-ldflags -Wl,*

	set_arch_to_kernel
	local myeconfargs=(
		--bindir="${EPREFIX}/bin"
		--sbindir="${EPREFIX}/sbin"
		--with-config=all
		--with-linux="${KV_DIR}"
		--with-linux-obj="${KV_OUT_DIR}"
		$(use_enable debug)
		$(use_enable debug-log)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	dodoc AUTHORS DISCLAIMER README.markdown
}

pkg_postinst() {
	linux-mod_pkg_postinst

	# Remove old modules
	if [ -d "${EROOT}lib/modules/${KV_FULL}/addon/spl" ]
	then
		ewarn "${PN} now installs modules in ${EROOT}lib/modules/${KV_FULL}/extra/spl"
		ewarn "Old modules were detected in ${EROOT}lib/modules/${KV_FULL}/addon/spl"
		ewarn "Automatically removing old modules to avoid problems."
		rm -r "${EROOT}lib/modules/${KV_FULL}/addon/spl" || die "Cannot remove modules"
		rmdir --ignore-fail-on-non-empty "${EROOT}lib/modules/${KV_FULL}/addon"
	fi
}
