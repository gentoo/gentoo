# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1
inherit bash-completion-r1 elisp-common

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://git.zx2c4.com/password-store"
	inherit git-r3
else
	SRC_URI="https://git.zx2c4.com/password-store/snapshot/password-store-${PV}.tar.xz"
	S="${WORKDIR}/password-store-${PV}"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~x64-macos"
fi

DESCRIPTION="Stores, retrieves, generates, and synchronizes passwords securely"
HOMEPAGE="https://www.passwordstore.org/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+git wayland X emacs dmenu importers"

RDEPEND="
	app-crypt/gnupg
	media-gfx/qrencode[png(+)]
	>=app-text/tree-1.7.0
	git? ( dev-vcs/git )
	wayland? ( gui-apps/wl-clipboard )
	X? ( x11-misc/xclip )
	elibc_Darwin? ( app-misc/getopt )
	dmenu? ( x11-misc/dmenu x11-misc/xdotool )
	emacs? ( >=app-editors/emacs-26.1:* >=app-emacs/with-editor-2.5.11 )
"

src_prepare() {
	default

	use elibc_Darwin || return
	# use coreutils'
	sed -i -e 's/openssl base64/base64/g' src/platform/darwin.sh || die
	# host getopt isn't cool, and we aren't brew (rip out brew reference)
	sed -i -e '/^GETOPT=/s/=.*$/=getopt-long/' src/platform/darwin.sh || die
	# make sure we can find "mount"
	sed -i -e 's:mount -t:/sbin/mount -t:' src/platform/darwin.sh || die
}

src_compile() {
	use emacs && elisp-compile contrib/emacs/*.el
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		BASHCOMPDIR="$(get_bashcompdir)" \
		WITH_BASHCOMP=yes \
		WITH_ZSHCOMP=yes \
		WITH_FISHCOMP=yes

	use dmenu && dobin contrib/dmenu/passmenu

	if use emacs; then
		elisp-install password-store contrib/emacs/*.{el,elc}
		elisp-site-file-install "${FILESDIR}/50password-store-gentoo.el"
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
		einfo "    ${EROOT}/usr/share/${PN}/importers/"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
