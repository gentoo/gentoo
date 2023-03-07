# Copyright 1999-2023 Gentoo Authors
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

	# The Desktop Entry Specification does not allow field codes like %u
	# inside a quoted argument, therefore we need a shell wrapper.
	# We pass the following commands to it, in order to backslash-escape
	# any special characters '\' and '"' that occur in %u:
	#   u=${1//\\/\\\\}
	#   u=${u//\"/\\\"}
	#   exec emacsclient --eval "(message-mailto \"$u\")"
	# However, in the desktop entry '"', '\', and '$' must be escaped
	# as '\\"', '\\\\', and '\\$', respectively. Yet another level of
	# backslash escapes is needed for '\' and '$' in the here-document.
	newmenu - emacsclient-mail.desktop <<-EOF
		[Desktop Entry]
		Type=Application
		Name=Emacsclient (mail)
		NoDisplay=true
		Exec=${EPREFIX}/bin/bash -c \
"u=\\\\\${1//\\\\\\\\\\\\\\\\/\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\}; \
u=\\\\\${u//\\\\\\\\\\\\"/\\\\\\\\\\\\\\\\\\\\\\\\\\\\"}; \
exec ${EPREFIX}/usr/bin/emacsclient \
--eval \\\\"(message-mailto \\\\\\\\\\\\"\\\\\$u\\\\\\\\\\\\")\\\\"" bash %u
		Terminal=false
		MimeType=x-scheme-handler/mailto;
	EOF
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
