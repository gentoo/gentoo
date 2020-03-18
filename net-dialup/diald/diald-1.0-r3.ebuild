# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools pam

DESCRIPTION="Daemon that provides on demand IP links via SLIP or PPP"
HOMEPAGE="http://diald.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Old-MIT GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="pam"

DEPEND="pam? ( sys-libs/pam )
	sys-apps/tcp-wrappers"
RDEPEND="${DEPEND}
	net-dialup/ppp"

src_prepare() {
	eapply "${FILESDIR}/${P}-posix.patch"
	eapply "${FILESDIR}/${P}-gentoo.patch"
	if ! use pam; then
		eapply "${FILESDIR}/${P}-nopam.patch"
		rm "${S}"/README.pam
		cd "${S}"
		eautoconf
	fi
	eapply_user
}

src_install() {
	emake \
		DESTDIR="${D}" \
		sysconfdir=/etc \
		bindir=/usr/bin \
		sbindir=/usr/sbin \
		mandir=/usr/share/man \
		libdir=/usr/lib/diald \
		BINGRP=root \
		ROOTUID=root \
		ROOTGRP=root \
		install
	use pam && pamd_mimic_system diald auth account

	dodir /var/cache/diald
	mknod -m 0660 "${D}/var/cache/diald/diald.ctl" p

	dodoc BUGS CHANGES NOTES README* \
		THANKS TODO TODO.budget doc/diald-faq.txt
	docinto setup ; cp -pPR setup/* "${D}/usr/share/doc/${PF}/setup"
	docinto contrib ; cp -pPR contrib/* "${D}/usr/share/doc/${PF}/contrib"

	insinto /etc/diald ; doins "${FILESDIR}"/{diald.conf,diald.filter}
	newinitd "${FILESDIR}/diald-init" diald
}
