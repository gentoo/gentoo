# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="A dovecot antispam plugin supporting multiple backends"
HOMEPAGE="http://wiki2.dovecot.org/Plugins/Antispam/"
SRC_URI="https://dev.gentoo.org/~radhermit/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND=">=net-mail/dovecot-2.1.16"
RDEPEND="${DEPEND}"

DOCS=( README )

src_prepare() {
	AT_M4DIR="m4" eautoreconf
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "You will need to install mail-filter/dspam or app-text/crm114"
		elog "if you want to use the related backends in dovecot-antispam."
		elog
	fi
}
