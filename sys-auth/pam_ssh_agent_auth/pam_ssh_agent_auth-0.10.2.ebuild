# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit pam

DESCRIPTION="Simple module to authenticate users against their ssh-agent keys"
HOMEPAGE="http://pamsshagentauth.sourceforge.net"
SRC_URI="mirror://sourceforge/pamsshagentauth/${PN}/v${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/pam
	dev-libs/openssl"

RDEPEND="${DEPEND}
	virtual/ssh"

# needed for pod2man
DEPEND="${DEPEND}
	dev-lang/perl"

src_configure() {
	pammod_hide_symbols

	econf \
		--libexecdir="$(getpam_mod_dir)"
}

src_install() {
	# Don't use emake install as it makes it harder to have proper
	# install paths.
	dopammod pam_ssh_agent_auth.so
	doman pam_ssh_agent_auth.8

	dodoc CONTRIBUTORS
}
