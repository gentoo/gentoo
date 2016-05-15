# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools

DESCRIPTION="A daemon forwarding CAPI messages to capi20proxy clients"
HOMEPAGE="http://capi20proxy.sourceforge.net/"
SRC_URI="mirror://sourceforge/capi20proxy/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-dialup/capi4k-utils"

S="${WORKDIR}/linux-server"

src_prepare() {
	eapply -p0 "${FILESDIR}/${P}.patch"
	eapply -p0 "${FILESDIR}/${P}-amd64.patch"

	# Replace obsolete sys_errlist with strerror
	sed -i -e 's:sys_errlist *\[ *errno *\]:strerror(errno):' \
		src/capifwd.c src/capi/waitforsignal.c src/auth/auth.c || \
		die "failed to replace sys_errlist"

	eapply_user
	eautoreconf
}

src_install() {
	emake DESTDIR="$D" install
	dodoc AUTHORS ChangeLog README

	# install init-script
	newinitd "${FILESDIR}/capifwd.init" capifwd
	newconfd "${FILESDIR}/capifwd.conf" capifwd
}
