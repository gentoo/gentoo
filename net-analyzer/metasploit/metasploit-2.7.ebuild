# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/metasploit/metasploit-2.7.ebuild,v 1.9 2012/04/21 16:54:21 armin76 Exp $

MY_P="${P/metasploit/framework}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Advanced open-source framework for developing, testing, and using vulnerability exploit code"
HOMEPAGE="http://www.metasploit.org/"
SRC_URI="http://metasploit.com/tools/${MY_P}.tar.gz"

LICENSE="GPL-2 Artistic"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/perl
	 dev-perl/Net-SSLeay
	 dev-perl/Term-ReadLine-Perl
	 dev-perl/TermReadKey"

src_install() {
	dodir /usr/lib/
	dodir /usr/bin/

	# should be as simple as copying everything into the target...
	cp -pPR "${S}" "${D}"usr/lib/metasploit || die

	# and creating symlinks in the /usr/bin dir
	cd "${D}"/usr/bin
	ln -s ../lib/metasploit/msf* ./ || die
	chown -R root:0 "${D}"

	newinitd "${FILESDIR}"/msfweb.initd msfweb || die "newinitd failed"
	newconfd "${FILESDIR}"/msfweb.confd msfweb || die "newconfd failed"
}

pkg_postinst() {
	elog "To update metasploit modules run:"
	elog " # cd /usr/lib/metasploit && svn update"
}

pkg_postrm() {
	if [[ -d /usr/lib/metasploit ]] ; then
		ewarn "If you ever updated modules emerge will keep /var/lib/metasploit"
		ewarn "directory. Thus to remove metasploit completely do not forgive to:"
		ewarn " # rm -r /usr/lib/metasploit"
	fi
}
