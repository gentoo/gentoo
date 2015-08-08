# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Virtual Router Redundancy Protocol Daemon"
HOMEPAGE="http://numsys.eu/vrrp_art.php"
SRC_URI="https://github.com/fredbcode/Vrrpd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="sys-devel/gcc"
RDEPEND=""
S="${WORKDIR}/Vrrpd-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/vrrpd-1.9-rollup.patch || die
	emake mrproper
	#rm -f atropos
}

src_compile() {
	emake DBG_OPT="" MACHINEOPT="${CFLAGS}" PROF_OPT="${LDFLAGS}"
}

src_install() {
	dosbin vrrpd atropos
	doman vrrpd.8
	dodoc FAQ Changes TODO scott_example doc/draft-ietf-vrrp-spec-v2-05.txt doc/rfc2338.txt.vrrp doc/draft-jou-duplicate-ip-address-02.txt doc/principe-Vrrp1.jpg doc/principe-Vrrp2.jpg README.md
}
