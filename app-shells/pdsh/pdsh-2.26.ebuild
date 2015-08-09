# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="A high-performance, parallel remote shell utility"
HOMEPAGE="https://computing.llnl.gov/linux/pdsh.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt readline rsh static-libs test"

RDEPEND="crypt? ( net-misc/openssh )
	rsh? ( net-misc/netkit-rsh )
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

pkg_setup() {
	local m
	local valid_modules=":xcpu:ssh:exec:qshell:genders:nodeupdown:mrsh:mqshell:dshgroups:netgroup:"

	PDSH_MODULE_LIST="${PDSH_MODULE_LIST:-netgroup}"
	MODULE_CONFIG=""
	for m in ${PDSH_MODULE_LIST}; do
		if [[ "${valid_modules}" == *:${m}:* ]]; then
			MODULE_CONFIG="${MODULE_CONFIG} --with-${m}"
		fi
	done

	elog "Building ${PF} with the following modules:"
	elog "  ${PDSH_MODULE_LIST}"
	elog "This list can be changed in /etc/make.conf by setting"
	elog "PDSH_MODULE_LIST=\"module1 module2...\""
}

src_configure() {
	econf ${MODULE_CONFIG} \
		--with-machines \
		--enable-shared \
		$(use_with crypt ssh) \
		$(use_with rsh) \
		$(use_with readline) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
