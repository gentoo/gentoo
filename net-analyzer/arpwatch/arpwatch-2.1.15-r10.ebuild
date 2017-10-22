# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user versionator

PATCH_VER="0.8"
MY_P="${PN}-$(replace_version_separator 2 'a')"

DESCRIPTION="An ethernet monitor program that keeps track of ethernet/IP address pairings"
HOMEPAGE="http://ee.lbl.gov/"
SRC_URI="
	ftp://ftp.ee.lbl.gov/${MY_P}.tar.gz
	https://dev.gentoo.org/~jer/arpwatch-patchset-${PATCH_VER}.tar.xz
"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="selinux"

DEPEND="
	net-libs/libpcap
	sys-libs/ncurses:*
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-arpwatch )
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	# We need to create /var/lib/arpwatch with this group, so it must
	# exist during src_install.
	enewgroup arpwatch
}

pkg_postinst() {
	# The user, however, is not needed until runtime.
	enewuser arpwatch -1 -1 -1 arpwatch
}

src_prepare() {
	local patchdir="${WORKDIR}/arpwatch-patchset"

	eapply "${patchdir}"/*.patch
	eapply_user

	cp "${patchdir}"/*.8 ./ || die "failed to copy man pages from ${patchdir}"
}

src_install () {
	dosbin arpwatch arpsnmp arp2ethers massagevendor arpfetch bihourly.sh
	doman arpwatch.8 arpsnmp.8 arp2ethers.8 massagevendor.8 arpfetch.8 bihourly.8

	insinto /usr/share/arpwatch
	doins ethercodes.dat

	insinto /usr/share/arpwatch/awk
	doins duplicates.awk euppertolower.awk p.awk e.awk d.awk

	diropts --group=arpwatch --mode=770
	dodir /var/lib/arpwatch
	dodoc README CHANGES

	newinitd "${FILESDIR}"/arpwatch.initd-r1 arpwatch
	newconfd "${FILESDIR}"/arpwatch.confd-r1 arpwatch
}
