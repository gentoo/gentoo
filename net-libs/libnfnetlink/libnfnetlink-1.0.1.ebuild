# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

PATCH_BLOB=04aef8a4dedf267dd5744afb134ef8046e77f613
PATCH_FN=${PATCH_BLOB}-musl-fix-includes.patch

DESCRIPTION="the low-level library for netfilter related kernel/userspace communication"
HOMEPAGE="http://www.netfilter.org/projects/libnfnetlink/"
SRC_URI="
	http://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2
	https://git.alpinelinux.org/cgit/aports/plain/main/libnfnetlink/musl-fix-includes.patch -> ${PATCH_FN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sparc x86"

PATCHES=( "${DISTDIR}/${PATCH_FN}" )

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is lt 2 6 18 ; then
		ewarn "${PN} requires at least 2.6.18 kernel version"
	fi

	#netfilter core team has changed some option names with kernel 2.6.20
	error_common=' is not set when it should be. You can activate it in the Core Netfilter Configuration'
	if kernel_is lt 2 6 20 ; then
		CONFIG_CHECK="~IP_NF_CONNTRACK_NETLINK"
		ERROR_IP_NF_CONNTRACK_NETLINK="CONFIG_IP_NF_CONNTRACK_NETLINK:\t${error_common}"
	else
		CONFIG_CHECK="~NF_CT_NETLINK"
		ERROR_NF_CT_NETLINK="CONFIG_NF_CT_NETLINK:\t${error_common}"
	fi

	check_extra_config
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
