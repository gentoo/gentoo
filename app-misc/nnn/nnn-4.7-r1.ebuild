# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 flag-o-matic toolchain-funcs xdg

DESCRIPTION="The missing terminal file browser for X"
HOMEPAGE="https://github.com/jarun/nnn"
SRC_URI="https://github.com/jarun/nnn/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+readline pcre 8contexts icons nerdfonts emoji qsort colemak gitstatus namefirst restorepreview"

DEPEND="sys-libs/ncurses:=
	pcre? ( dev-libs/libpcre )
	readline? ( sys-libs/readline:= )
	elibc_musl? ( sys-libs/fts-standalone )"
BDEPEND="virtual/pkgconfig"
RDEPEND="${DEPEND}"
REQUIRED_USE="?? ( icons nerdfonts emoji )"

src_prepare() {
	default
	tc-export CC
	use elibc_musl && append-flags "-lfts"
	# When using nnn's bundled patches, the 'install' target should not depend
	# on 'all'. See: https://github.com/jarun/nnn/issues/1493
	sed -i -e 's/install: all/install:/' Makefile || die "sed failed"
}

src_compile() {
	nnn_opts=(
		O_NORL=$(usex readline 0 1)
		O_PCRE=$(usex pcre 1 0)
		O_CTX8=$(usex 8contexts 1 0)
		O_ICONS=$(usex icons 1 0)
		O_NERD=$(usex nerdfonts 1 0)
		O_EMOJI=$(usex emoji 1 0)
		O_QSORT=$(usex qsort 1 0)
		# nnn's user-submitted patches
		O_COLEMAK=$(usex colemak 1 0)
		O_GITSTATUS=$(usex gitstatus 1 0)
		O_NAMEFIRST=$(usex namefirst 1 0)
		O_RESTOREPREVIEW=$(usex restorepreview 1 0)
	)
	emake "${nnn_opts[@]}"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install

	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install-desktop

	newbashcomp misc/auto-completion/bash/nnn-completion.bash nnn

	insinto /usr/share/fish/vendor_completions.d
	doins misc/auto-completion/fish/nnn.fish

	insinto /usr/share/zsh/site-functions
	doins misc/auto-completion/zsh/_nnn

	einstalldocs

	insinto /usr/share/nnn
	insopts -m0755
	doins -r plugins
	fperms 0644 /usr/share/nnn/plugins/README.md
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "nnn plugins are installed to /usr/share/nnn/plugins/, but nnn does not"
	elog "load them fom this directory. You will need to copy/symlink them to"
	elog "~/.config/nnn/plugins/ if you want to use them."
	elog "Note that some plugins have runtime dependencies that may need to be installed."
	elog "Refer to the individual plugin's in-file documentation for more information."

	if use icons; then
		elog "In order for file icons to work, your terminal needs to use icons-in-terminal."
		elog "See https://github.com/sebastiencs/icons-in-terminal"
	elif use nerdfonts; then
		elog "In order for file icons to work, your terminal needs to use a patched nerdfont."
		elog "See https://www.nerdfonts.com/"
	elif use emoji; then
		elog "In order for file icons to work, your terminal needs to use a font that"
		elog "includes standard unicode emoji."
	fi
}
