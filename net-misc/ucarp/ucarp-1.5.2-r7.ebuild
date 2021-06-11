# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Portable userland implementation of Common Address Redundancy Protocol (CARP)"
HOMEPAGE="https://ucarp.wordpress.com"
SRC_URI="ftp://ftp.ucarp.org/pub/ucarp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="debug nls"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_configure() {
	econf \
		--disable-static \
		$(use_with debug) \
		$(use_enable nls)
}

src_install() {
	default

	doman "${FILESDIR}"/ucarp.8

	exeinto /usr/libexec/ucarp
	newexe "${FILESDIR}"/vip-up-default.sh-r1 vip-up-default.sh
	newexe "${FILESDIR}"/vip-down-default.sh-r1 vip-down-default.sh

	keepdir /etc/ucarp

	newinitd "${FILESDIR}"/ucarp.initd-r2 ucarp
	newconfd "${FILESDIR}"/ucarp.confd ucarp

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "The provided init script needs to be configured first."
	elog "Edit /etc/conf.d/ucarp to suite your environment."
	elog "You will also have to set a shared password within /etc/ucarp/ucarp.pass"
	elog "or whatever file you have set \$UCARP_PASSFILE to."

	elog "If you need more than one instance of ucarp running, simply symlink"
	elog "the init script and create a copy of the init script configuration"
	elog "which corresponds to the name of the init script."
}
