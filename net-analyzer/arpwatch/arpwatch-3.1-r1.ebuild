# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd user

DESCRIPTION="An ethernet monitor program that keeps track of ethernet/IP address pairings"
HOMEPAGE="https://ee.lbl.gov/"
LICENSE="BSD GPL-2"
SLOT="0"

ETHERCODES_DATE=20200628
SRC_URI="
	https://ee.lbl.gov/downloads/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~jer/ethercodes.dat-${ETHERCODES_DATE}.xz
"

KEYWORDS="amd64 ~hppa ~ppc ~sparc x86"
IUSE="selinux"

DEPEND="
	net-libs/libpcap
	sys-libs/ncurses:*
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-arpwatch )
	virtual/mta
"

pkg_setup() {
	# We need to create /var/lib/arpwatch with this group, so it must
	# exist during src_install.
	enewgroup arpwatch
}

pkg_postinst() {
	# The user, however, is not needed until runtime.
	enewuser arpwatch -1 -1 -1 arpwatch
}

src_configure() {
	econf \
		ac_cv_path_V_SENDMAIL=sendmail
}

src_install() {
	dosbin arp2ethers arpfetch arpsnmp arpwatch bihourly.sh massagevendor.py update-ethercodes.sh
	doman arpsnmp.8 arpwatch.8

	insinto /usr/share/arpwatch
	newins "${WORKDIR}"/ethercodes.dat-${ETHERCODES_DATE} ethercodes.dat

	insinto /usr/share/arpwatch/awk
	doins d.awk duplicates.awk e.awk euppertolower.awk p.awk

	diropts --group=arpwatch --mode=770
	keepdir /var/lib/arpwatch
	dodoc README CHANGES

	newconfd "${FILESDIR}"/arpwatch.confd-r2 arpwatch
	newinitd "${FILESDIR}"/arpwatch.initd-r2 arpwatch

	systemd_dounit "${FILESDIR}/arpwatch.service"
	systemd_install_serviced "${FILESDIR}/arpwatch.conf"
}

pkg_postinst() {
	# Previous revisions installed /var/lib/arpwatch with the wrong
	# ownership. Instead of the intended arpwatch:root, it was left as
	# root:root. If we find any such mis-owned directories, we fix them,
	# and then set the permission bits how we want them in *this*
	# revision.
	#
	# The "--from" flag ensures that we only fix directories that need
	# fixing, and the "&& chmod" ensures that we only adjust the
	# permissions if the owner also needed fixing.
	chown \
		--from=root:root \
		--no-dereference \
		:arpwatch \
		"${ROOT}"/var/lib/arpwatch && \
		chmod 770 "${ROOT}"/var/lib/arpwatch
}
