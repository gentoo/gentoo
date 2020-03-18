# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit bash-completion-r1 git-r3 elisp-common

DESCRIPTION="Stores, retrieves, generates, and synchronizes passwords securely"
HOMEPAGE="https://www.passwordstore.org/"
EGIT_REPO_URI="https://git.zx2c4.com/password-store"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="+git X zsh-completion fish-completion emacs dmenu importers elibc_Darwin"

RDEPEND="
	app-crypt/gnupg
	media-gfx/qrencode
	>=app-text/tree-1.7.0
	git? ( dev-vcs/git )
	X? ( x11-misc/xclip )
	elibc_Darwin? ( app-misc/getopt )
	zsh-completion? ( app-shells/gentoo-zsh-completions )
	fish-completion? ( app-shells/fish )
	dmenu? ( x11-misc/dmenu x11-misc/xdotool )
	emacs? ( >=app-editors/emacs-23.1:* )
"

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
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		BASHCOMPDIR="$(get_bashcompdir)" \
		WITH_BASHCOMP=yes \
		WITH_ZSHCOMP=$(usex zsh-completion) \
		WITH_FISHCOMP=$(usex fish-completion)
	use dmenu && dobin contrib/dmenu/passmenu
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
		einfo "    ${EROOT%/}/usr/share/${PN}/importers/"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
