# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam

DESCRIPTION="Simple module to authenticate users against their ssh-agent keys"
HOMEPAGE="http://pamsshagentauth.sourceforge.net"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/jbeverly/${PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/pamsshagentauth/${PN}/v${PV}/${P}.tar.bz2
	https://dev.gentoo.org/~juippis/distfiles/tmp/pam_ssh_agent_auth-0.10.3-openssl-1.1.1.patch"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

PATCHES=(
	"${DISTDIR}/${P}-openssl-1.1.1.patch"
)
DEPEND="sys-libs/pam
	dev-libs/openssl:0="

RDEPEND="${DEPEND}
	virtual/ssh"

# needed for pod2man
DEPEND="${DEPEND}
	dev-lang/perl"

src_configure() {
	pammod_hide_symbols

	econf \
		--without-openssl-header-check \
		--libexecdir="$(getpam_mod_dir)"
}

src_install() {
	# Don't use emake install as it makes it harder to have proper
	# install paths.
	dopammod pam_ssh_agent_auth.so
	doman pam_ssh_agent_auth.8

	dodoc CONTRIBUTORS
}
