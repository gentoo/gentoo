# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/hop/hop-2.0.1.ebuild,v 1.2 2012/06/07 20:34:19 zmedico Exp $

EAPI="2"

inherit eutils multilib user

DESCRIPTION="Hop is a higher-order language for programming interactive web applications"
HOMEPAGE="http://hop.inria.fr/"
SRC_URI="ftp://ftp-sop.inria.fr/indes/fp/Hop/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-scheme/bigloo-3.3a[ssl?,threads?]"

RDEPEND="${DEPEND}"

IUSE="ssl threads debug"

pkg_setup() {
	enewgroup hop
	enewuser hop -1 -1 /var/lib/hop hop
}

src_configure() {
	# Hop doesn't use autoconf and consequently a lot of options used by econf give errors
	# Manuel Serrano says: "Please, dont talk to me about autoconf. I simply dont want to hear about it..."
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--libdir=/usr/$(get_libdir) \
		--etcdir=/etc/hop \
		$(use_enable ssl) \
		$(use_enable threads) \
		$(use debug && echo "--debug") \
		|| die "configure failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "install failed"

	newinitd "${FILESDIR}/hop.initd" hop || die
	newconfd "${FILESDIR}/hop.confd" hop || die
}
