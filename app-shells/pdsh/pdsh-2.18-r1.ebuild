# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils autotools

DESCRIPTION="A high-performance, parallel remote shell utility"
HOMEPAGE="https://computing.llnl.gov/linux/pdsh.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="crypt readline rsh"
RDEPEND="crypt? ( net-misc/openssh )
	rsh? ( net-misc/netkit-rsh )
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}"

# Feel free to debug the test suite.  Running the tests
# by hand instead of using pdsh.exp seems to print out
# what is expected, so the error is most likely in the
# testsuite itself.
# You'll also need dev-util/dejagnu
RESTRICT="test"

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

src_prepare() {
	epatch "${FILESDIR}"/pdsh-2.18-unbundle-libtool.patch
	eautoreconf
}

src_configure() {
	econf ${MODULE_CONFIG} \
		--with-machines \
		$(use_with crypt ssh) \
		$(use_with rsh) \
		$(use_with readline) \
		|| die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
