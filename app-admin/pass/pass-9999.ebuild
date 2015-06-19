# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/pass/pass-9999.ebuild,v 1.21 2015/02/15 14:17:49 mgorny Exp $

EAPI=5

inherit bash-completion-r1 git-2 elisp-common

DESCRIPTION="Stores, retrieves, generates, and synchronizes passwords securely using gpg, pwgen, and git"
HOMEPAGE="http://www.passwordstore.org/"
EGIT_REPO_URI="http://git.zx2c4.com/password-store"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="+git X zsh-completion fish-completion emacs dmenu importers elibc_Darwin"

RDEPEND="
	app-crypt/gnupg
	app-admin/pwgen
	>=app-text/tree-1.7.0
	git? ( dev-vcs/git )
	X? ( x11-misc/xclip )
	elibc_Darwin? ( app-misc/getopt )
	zsh-completion? ( app-shells/gentoo-zsh-completions )
	fish-completion? ( app-shells/fish )
	dmenu? ( x11-misc/dmenu x11-misc/xdotool )
	emacs? ( virtual/emacs )
"

S="${WORKDIR}/password-store-${PV}"

src_prepare() {
	use elibc_Darwin || return
	# use coreutils'
	sed -i -e 's/openssl base64/base64/g' src/platform/darwin.sh || die
	# host getopt isn't cool, and we aren't brew (rip out brew reference)
	sed -i -e '/^GETOPT=/s/=.*$/=getopt-long/' src/platform/darwin.sh || die
	# make sure we can find "mount"
	sed -i -e 's:mount -t:/sbin/mount -t:' src/platform/darwin.sh || die
}

src_compile() {
	:;
}

src_install() {
	use zsh-completion && export FORCE_ZSHCOMP=1
	use fish-completion && export FORCE_FISHCOMP=1
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	use dmenu && dobin contrib/dmenu/passmenu
	newbashcomp src/completion/pass.bash-completion pass
	if use emacs; then
		elisp-install ${PN} contrib/emacs/*.el
		elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el"
	fi
	if use importers; then
		exeinto /usr/share/${PN}/importers
		doexe contrib/importers/*
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	if use importers; then
		einfo "To import passwords from other password managers, you may use the"
		einfo "various importer scripts found in:"
		einfo "    ${ROOT}usr/share/${PN}/importers/"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
