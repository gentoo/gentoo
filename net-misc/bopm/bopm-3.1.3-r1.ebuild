# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib user

DESCRIPTION="Blitzed Open Proxy Monitor"
HOMEPAGE="http://www.blitzed.org/bopm/"
SRC_URI="http://static.blitzed.org/www.blitzed.org/${PN}/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--datadir="${EPREFIX}"/usr/share/doc/${PF} \
		--localstatedir="${EPREFIX}"/var/log/${PN}
}

src_install () {
	sed -i \
		-e "s!/some/path/bopm.pid!/run/${PN}/${PN}.pid!" \
		-e "s!/some/path/scan.log!/var/log/${PN}/scan.log!" \
		bopm.conf.sample || die

	# Custom Makefile.am rules do not respect DESTDIR,
	# thus override sysconfdir and localstatedir.
	emake \
		DESTDIR="${D}" \
		sysconfdir="${ED}"/etc \
		localstatedir="${ED}"/var/log/bopm \
		install || die "install failed"

	fperms 600 /etc/bopm.conf

	# Remove libopm related files, because bopm links statically to it
	# If anybody wants libopm, please install net-libs/libopm
	rm -r "${ED}"/usr/$(get_libdir) "${ED}"/usr/include || die

	newinitd "${FILESDIR}"/bopm.init.d-r1 ${PN}
	newconfd "${FILESDIR}"/bopm.conf.d-r1 ${PN}

	dodoc ChangeLog INSTALL README TODO
}

pkg_postinst() {
	enewuser bopm

	install -d -m 0700 -o bopm -g root "${ROOT}"/var/log/bopm
	chown bopm "${ROOT}"/etc/bopm.conf
}
