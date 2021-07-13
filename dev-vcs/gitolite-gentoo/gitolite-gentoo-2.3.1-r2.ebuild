# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Highly flexible server for git directory version tracker, Gentoo fork"
HOMEPAGE="https://cgit.gentoo.org/proj/gitolite-gentoo.git"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="contrib vim-syntax"

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
	!dev-vcs/gitolite
	dev-perl/Net-SSH-AuthorizedKeysFile
	vim-syntax? ( app-vim/gitolite-syntax )"

src_prepare() {
	default

	rm Makefile doc/COPYING || die
	rm -rf contrib/{gitweb,vim} || die

	echo "${PF}-gentoo" > conf/VERSION
}

src_install() {
	local gl_bin="${D}/usr/bin"
	gl_bin=${gl_bin/\/\//\/}

	dodir /usr/share/gitolite/{conf,hooks} /usr/bin

	export PATH="${gl_bin}:${PATH}"
	./src/gl-system-install ${gl_bin} \
		"${D}"/usr/share/gitolite/conf "${D}"/usr/share/gitolite/hooks || die
	sed -e "s:${D}::g" "${D}/usr/bin/gl-setup" \
		-i "${D}/usr/share/gitolite/conf/example.gitolite.rc" || die

	rm "${D}"/usr/bin/*.pm
	insinto "${VENDOR_LIB}"
	doins src/*.pm

	dodoc README.mkd doc/*

	use contrib && dodoc -r contrib
}

pkg_postinst() {
	# bug 352291
	ewarn
	elog "Please make sure that your 'git' user has the correct homedir (/var/lib/gitolite)."
	elog "Especially if you're migrating from gitosis."
	ewarn
	ewarn
	elog "If you use the umask feature and upgrade from <=gitolite-gentoo-1.5.9.1"
	elog "then please check the permissions of all repositories using the umask feature"
	ewarn
}
