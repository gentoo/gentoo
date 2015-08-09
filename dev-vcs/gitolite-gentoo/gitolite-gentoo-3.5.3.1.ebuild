# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module user versionator

DESCRIPTION="Highly flexible server for git directory version tracker, Gentoo fork"
HOMEPAGE="http://cgit.gentoo.org/proj/gitolite-gentoo.git"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools vim-syntax"

DEPEND="dev-lang/perl
	virtual/perl-File-Path
	virtual/perl-File-Temp
	>=dev-vcs/git-1.6.6"
RDEPEND="${DEPEND}
	!dev-vcs/gitolite
	dev-perl/Net-SSH-AuthorizedKeysFile
	vim-syntax? ( app-vim/gitolite-syntax )"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/sh /var/lib/gitolite git
}

src_prepare() {
	echo "${PF}-gentoo" > src/VERSION
}

src_install() {
	local uexec=/usr/libexec/${PN}

	rm -rf src/lib/Gitolite/Test{,.pm}
	insinto $VENDOR_LIB
	doins -r src/lib/Gitolite

	dodoc README.txt CHANGELOG

	insopts -m0755
	insinto $uexec
	doins -r src/{commands,syntactic-sugar,triggers,VREF}/

	insopts -m0644
	doins src/VERSION

	exeinto $uexec
	doexe src/gitolite{,-shell}

	dodir /usr/bin
	for bin in gitolite{,-shell}; do
		dosym /usr/libexec/${PN}/${bin} /usr/bin/${bin}
	done

	if use tools; then
		dobin check-g2-compat convert-gitosis-conf
	fi

	keepdir /var/lib/gitolite
	fowners git:git /var/lib/gitolite
	fperms 750 /var/lib/gitolite

	fperms 0644 ${uexec}/VREF/MERGE-CHECK # It's meant as example only
}

pkg_postinst() {
	if [ "$(get_major_version $REPLACING_VERSIONS)" = "2" ]; then
		ewarn
		elog "***NOTE*** This is a major upgrade and will likely break your existing gitolite-2.x setup!"
		elog "Please read http://gitolite.com/gitolite/migr.html first!"
		ewarn
		elog "***NOTE*** If you're using the \"umask\" feature of ${PN}-2.x:"
		elog "You'll have to replace each \"umask = ...\" option by \"option umask = ...\""
		elog "And you'll also have to enable the \"RepoUmask\" module in your .gitolite.rc"
		ewarn
	fi

	# bug 352291
	gitolite_home=$(awk -F: '$1 == "git" { print $6 }' /etc/passwd)
	if [ -n "${gitolite_home}" -a "${gitolite_home}" != "/var/lib/gitolite" ]; then
		ewarn
		elog "Please make sure that your 'git' user has the correct homedir (/var/lib/gitolite)."
		elog "Especially if you're migrating from gitosis."
		ewarn
	fi
}
