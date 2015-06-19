# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ssh-chain/ssh-chain-20131217.ebuild,v 1.1 2013/12/18 18:31:07 ottxor Exp $

EAPI=5

inherit vcs-snapshot

COMMIT="c1bd9d82d750bf001d12a9cd41b9b24a3fd84f81"
DESCRIPTION="ssh via a chain of intermediary hosts"
HOMEPAGE="https://github.com/ryancdotorg/ssh-chain"
SRC_URI="${HOMEPAGE}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl
	virtual/ssh"

src_install() {
	dobin "${PN}"
	dodoc README
	if [[ -f "${EROOT}"/etc/ssh/ssh_config ]] && ! grep -q "^Host \*^\*" "${EROOT}"/etc/ssh/ssh_config; then
		cp "${EROOT}"/etc/ssh/ssh_config "${T}/ssh_config"
		cat >> "${T}/ssh_config" <<EOF

#for ${PN}
Host *^*
	ProxyCommand ssh-chain %h %p

EOF
		insinto /etc/ssh
		doins "${T}/ssh_config"
	fi
}
