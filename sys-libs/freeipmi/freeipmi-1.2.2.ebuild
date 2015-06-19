# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/freeipmi/freeipmi-1.2.2.ebuild,v 1.4 2014/03/01 22:12:26 mgorny Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Provides Remote-Console and System Management Software as per IPMI v1.5/2.0"
HOMEPAGE="http://www.gnu.org/software/freeipmi/"

MY_P="${P/_/.}"
S="${WORKDIR}"/${MY_P}
[[ ${MY_P} == *.beta* ]] && ALPHA="-alpha"
SRC_URI="mirror://gnu${ALPHA}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="dev-libs/libgcrypt:0"
DEPEND="${RDEPEND}
		virtual/os-headers"
RDEPEND="${RDEPEND}
	sys-apps/openrc"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.1.1-strictaliasing.patch

	AT_M4DIR="config" eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--disable-dependency-tracking \
		--enable-fast-install \
		--disable-static \
		--disable-init-scripts \
		--localstatedir=/var
}

# There are no tests
src_test() { :; }

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" install
	find "${D}" -name '*.la' -delete

	# freeipmi by defaults install _all_ commands to /usr/sbin, but
	# quite a few can be run remotely as standard user, so move them
	# in /usr/bin afterwards.
	dodir /usr/bin
	for file in ipmi{detect,ping,power,console}; do
		mv "${D}"/usr/{s,}bin/${file} || die

		# The default install symlinks these commands to add a dash
		# after the ipmi prefix; we repeat those after move for
		# consistency.
		rm "${D}"/usr/sbin/${file/ipmi/ipmi-}
		dosym ${file} /usr/bin/${file/ipmi/ipmi-}
	done

	dodoc AUTHORS ChangeLog* DISCLAIMER* NEWS README* TODO doc/*.txt

	keepdir \
		/var/cache/ipmimonitoringsdrcache \
		/var/lib/freeipmi \
		/var/log/ipmiconsole

	# starting from version 1.2.0 the two daemons are similar enough
	newinitd "${FILESDIR}"/bmc-watchdog.initd.4 ipmidetectd
	newconfd "${FILESDIR}"/ipmidetectd.confd ipmidetectd

	newinitd "${FILESDIR}"/bmc-watchdog.initd.4 bmc-watchdog
	newconfd "${FILESDIR}"/bmc-watchdog.confd bmc-watchdog

	newinitd "${FILESDIR}"/bmc-watchdog.initd.4 ipmiseld
	newconfd "${FILESDIR}"/ipmiseld.confd ipmiseld
}
