# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="A daemon forwarding CAPI messages to capi20proxy clients"
HOMEPAGE="http://capi20proxy.sourceforge.net/"
SRC_URI="mirror://sourceforge/capi20proxy/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-dialup/capi4k-utils"

S="${WORKDIR}/linux-server"

PATCHES=(
	"${FILESDIR}/${P}-r1.patch"
	"${FILESDIR}/${P}-amd64-r1.patch"
)

src_prepare() {
	default

	# Replace obsolete sys_errlist with strerror
	sed -i -e 's:sys_errlist *\[ *errno *\]:strerror(errno):' \
		src/capifwd.c src/capi/waitforsignal.c src/auth/auth.c \
		|| die 'failed to replace sys_errlist'

	# We don't patch autotools, but it's already screwed up, so this
	# fixes a big QA warning.
	eautoreconf
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
}
