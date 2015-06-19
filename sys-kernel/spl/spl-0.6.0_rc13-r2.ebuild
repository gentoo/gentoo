# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/spl/spl-0.6.0_rc13-r2.ebuild,v 1.7 2015/05/15 18:25:55 blueness Exp $

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
		ZLIB_DEFLATE
		ZLIB_INFLATE
	"

	kernel_is ge 2 6 26 || die "Linux 2.6.26 or newer required"

	[ ${PV} != "9999" ] && \
		{ kernel_is le 3 8 || die "Linux 3.8 is the latest supported version."; }

	check_extra_config
}

src_prepare() {
	# Workaround for hard coded path
	sed -i "s|/sbin/lsmod|/bin/lsmod|" scripts/check.sh || die

	if [ ${PV} != "9999" ]
	then
		# Fix on_each_cpu autotools to work correctly
		epatch "${FILESDIR}/${P}-fix-on_each_cpu-autotools-check.patch"

		# Fix soft lockup regression
		epatch "${FILESDIR}/${P}-fix-soft-lockup.patch"

		# Fix x86 build failures on Linux 3.4 and later, bug #450646
		epatch "${FILESDIR}/${PN}-0.6.0_rc14-fix-atomic64-checks.patch"

		# Fix autotools check that fails on ~ppc64
		epatch "${FILESDIR}/${PN}-0.6.0_rc14-fix-mutex-owner-check.patch"
	fi

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

src_test() {
	if [[ ! -e /proc/modules ]]
	then
		die  "Missing /proc/modules"
	elif [[ $UID -ne 0 ]]
	then
		ewarn "Cannot run make check tests with FEATURES=userpriv."
		ewarn "Skipping make check tests."
	elif grep -q '^spl ' /proc/modules
	then
		ewarn "Cannot run make check tests with module spl loaded."
		ewarn "Skipping make check tests."
	else
		autotools-utils_src_test
	fi
}
