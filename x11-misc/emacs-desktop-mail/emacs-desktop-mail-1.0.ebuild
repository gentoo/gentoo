# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=28

inherit elisp desktop xdg-utils

DESCRIPTION="Desktop entries for handling mailto URIs with GNU Emacs"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() { :; }

src_install() {
	newmenu - emacs-mail.desktop <<-EOF
		[Desktop Entry]
		Type=Application
		Name=GNU Emacs (mail)
		NoDisplay=true
		Exec=${EPREXIX}/usr/bin/emacs -f message-mailto %u
		Terminal=false
		MimeType=x-scheme-handler/mailto;
	EOF

	newmenu - emacsclient-mail.desktop <<-EOF
		[Desktop Entry]
		Type=Application
		Name=Emacsclient (mail)
		NoDisplay=true
		Exec=${EPREFIX}/usr/libexec/emacs/emacsclient-mail-wrapper.sh %u
		Terminal=false
		MimeType=x-scheme-handler/mailto;
	EOF

	exeinto /usr/libexec/emacs
	newexe - emacsclient-mail-wrapper.sh <<-EOF
		#!${EPREXIX}/bin/bash
		exec ${EPREFIX}/usr/bin/emacsclient --eval "(message-mailto \\"\$1\\")"
	EOF
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
