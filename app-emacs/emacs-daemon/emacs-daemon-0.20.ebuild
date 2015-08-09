# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Gentoo support for Emacs running as a server in the background"
HOMEPAGE="http://wiki.gentoo.org/wiki/Project:Emacs"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"

DEPEND=">=virtual/emacs-23"
RDEPEND="${DEPEND}"

SITEFILE="10${PN}-gentoo.el"

pkg_setup() {
	local has_daemon has_gtk line
	has_daemon=$(${EMACS} ${EMACSFLAGS} --eval "(princ (fboundp 'daemonp))")
	has_gtk=$(${EMACS} ${EMACSFLAGS} --eval "(princ (featurep 'gtk))")

	if [[ ${has_daemon} != t ]]; then
		while read line; do ewarn "${line}"; done <<-EOF
		Your current Emacs version does not support running as a daemon
		which is required for ${CATEGORY}/${PN}.
		Use "eselect emacs" to select an Emacs version >= 23.
		EOF
	elif [[ ${has_gtk} == t ]]; then
		while read line; do ewarn "${line}"; done <<-EOF
		Your current Emacs is compiled with GTK+. There is a long-standing
		bug in GTK+ that prevents Emacs from recovering from X disconnects:
		<http://bugzilla.gnome.org/show_bug.cgi?id=85715>
		If you run Emacs as a daemon, then it is strongly recommended that
		you compile it with the Motif or the Lucid toolkit instead, i.e.
		with USE="motif -athena -gtk" or USE="athena -gtk -motif".
		EOF
	fi
}

src_compile() { :; }

src_install() {
	newinitd emacs.rc emacs
	newconfd emacs.conf emacs
	exeinto /usr/libexec/emacs
	doexe emacs-wrapper.sh emacs-stop.sh
	elisp-site-file-install "${SITEFILE}"
	dodoc README ChangeLog
}
