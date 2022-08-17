# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

[[ ${PV} == *9999 ]] && SCM="git-2"
EGIT_REPO_URI="git://git.gentoo.org/proj/gitolite-gentoo"
EGIT_MASTER=master

inherit perl-module ${SCM}

DESCRIPTION="Highly flexible server for git directory version tracker, Gentoo fork"
HOMEPAGE="https://cgit.gentoo.org/proj/gitolite-gentoo.git"
if [[ ${PV} != *9999 ]]; then
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	SRC_URI+=" https://github.com/sitaramc/gitolite/commit/5df2b817255ee919991da6c310239e08c8fcc1ae.patch"
	KEYWORDS="amd64 x86"
else
	SRC_URI=""
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="selinux tools vim-syntax"

DEPEND="
	dev-lang/perl
	>=dev-vcs/git-1.6.6
	virtual/perl-File-Path
	virtual/perl-File-Temp
"
RDEPEND="
	${DEPEND}
	acct-group/git
	acct-user/git[gitolite]
	>=dev-perl/Net-SSH-AuthorizedKeysFile-0.17
	dev-perl/JSON
	!dev-vcs/gitolite
	vim-syntax? ( app-vim/gitolite-syntax )
	selinux? ( sec-policy/selinux-gitosis )
"

PATCHES=(
	"${DISTDIR}"/5df2b817255ee919991da6c310239e08c8fcc1ae.patch
)

src_prepare() {
	default
	echo "${PF}-gentoo" > src/VERSION || die
}

src_install() {
	local uexec=/usr/libexec/${PN}

	rm -rf src/lib/Gitolite/Test{,.pm}
	insinto $VENDOR_LIB
	doins -r src/lib/Gitolite

	dodoc README.markdown CHANGELOG
	# These are meant by upstream as examples, you are strongly recommended to
	# customize them for your needs.
	dodoc contrib/utils/ipa_groups.pl contrib/utils/ldap_groups.sh

	insopts -m0755
	insinto $uexec
	doins -r src/{commands,syntactic-sugar,triggers,VREF}/
	doins -r contrib/{commands,triggers,hooks}

	insopts -m0644
	doins src/VERSION

	exeinto $uexec
	doexe src/gitolite{,-shell}

	dodir /usr/bin
	for bin in gitolite{,-shell}; do
		dosym ../libexec/${PN}/${bin} /usr/bin/${bin}
	done

	if use tools; then
		dobin check-g2-compat convert-gitosis-conf
		dobin contrib/utils/rc-format-v3.4
	fi

	fperms 0644 ${uexec}/VREF/MERGE-CHECK # It's meant as example only
}

pkg_postinst() {
	local old_ver
	for old_ver in ${REPLACING_VERSIONS}; do
		if ver_test ${old_ver} -lt "3" ; then
			ewarn
			elog "***NOTE*** This is a major upgrade and will likely break your existing gitolite-2.x setup!"
			elog "Please read http://gitolite.com/gitolite/migr.html first!"
			ewarn
			elog "***NOTE*** If you're using the \"umask\" feature of ${PN}-2.x:"
			elog "You'll have to replace each \"umask = ...\" option by \"option umask = ...\""
			elog "And you'll also have to enable the \"RepoUmask\" module in your .gitolite.rc"
			ewarn
		fi
	done

	# bug 352291
	gitolite_home=$(awk -F: '$1 == "git" { print $6 }' /etc/passwd)
	if [ -n "${gitolite_home}" -a "${gitolite_home}" != "/var/lib/gitolite" ]; then
		ewarn
		elog "Please make sure that your 'git' user has the correct homedir (/var/lib/gitolite)."
		elog "Especially if you're migrating from gitosis."
		ewarn
	fi
}
