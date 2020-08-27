# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Userspace helper for Linux kernel EDAC drivers"
HOMEPAGE="https://github.com/grondo/edac-utils"
SRC_URI="https://github.com/grondo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="sys-fs/sysfsutils"
RDEPEND="${DEPEND}
	sys-apps/dmidecode"

src_prepare() {
	default

	# <sys-devel/gcc-10, <sys-devel/binutils-2.34 do not support LDPT_ADD_SYMBOLS_V2
	# https://sourceware.org/bugzilla/show_bug.cgi?id=25355
	# We use Portage's build environment to determine which GCC and binutils version are
	# active. If either fail to meet the minimum version, -flto* is stripped from FLAGS
	local gcc_vers=$(gcc-version)
	local ld_vers=$($(tc-getLD) -v | sed 's/.*\(2\.[0-9][0-9]\).*/\1/')

	if [[ tc-is-gcc || ! tc-ld-is-lld ]]; then
		if tc-is-gcc && ver_test ${gcc_vers} -lt 10 ||
		! tc-ld-is-lld && ver_test ${ld_vers} -lt 2.34; then
			einfo "Toolchain is outdated, removed -flto flags"
			filter-flags -flto*
		fi
	fi

	# If Clang is used as compiler and LTO is enabled, ensure llvm-nm is used
	# This applies when using ld.bfd, ld.gold, or ld.lld
	if tc-is-clang && is-flag -flto*; then
		einfo "Enforcing NM=llvm-nm for Clang -flto"
		export NM=llvm-nm
	fi

	sed -i \
		-e 's|-Werror||' \
		configure || die

	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug)
}

src_install() {
	default

	# We don't need this init.d file
	# Modules should be loaded by adding them to /etc/conf.d/modules
	# The rest is done via the udev-rule
	rm -rf "${D}/etc/init.d" || die

	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	elog "There must be an entry for your mainboard in /etc/edac/labels.db"
	elog "in case you want nice labels in /sys/module/*_edac/"
	elog "Run the following command to check whether such an entry is already available:"
	elog "    edac-ctl --print-labels"
}
