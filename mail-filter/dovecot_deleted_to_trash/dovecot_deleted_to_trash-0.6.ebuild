# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Deleted to trash IMAP plugin for Dovecot"
HOMEPAGE="https://github.com/lexbrugman/dovecot_deleted_to_trash"
SRC_URI="https://github.com/lexbrugman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="=net-mail/dovecot-2.2*
	!!<net-mail/dovecot-2.2.0
	!!<=mail-filter/dovecot_deleted_to_trash-0.3
	"
DEPEND="${RDEPEND}"

src_prepare() {
	tc-export CC
	sed -i \
		-e "/DOVECOT_IMAP_PLUGIN_PATH/s:lib/dovecot/modules:$(get_libdir)/dovecot:" \
		-e "/PLUGIN_NAME/s/lib/lib99/" \
		Makefile || die
	epatch_user
}

src_install() {
	default
	insinto /etc/dovecot/conf.d
	doins "${FILESDIR}"/29-delete-to-trash.conf
}
