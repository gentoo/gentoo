# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

if [[ ${PV##*.} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/emacs-tools.git"
	EGIT_BRANCH="${PN}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}"
	S="${EGIT_CHECKOUT_DIR}"
else
	SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 sparc x86"
fi

DESCRIPTION="Gentoo support for Emacs running as a server in the background"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND=">=app-emacs/emacs-common-1.11"

pkg_setup() {
	local has_daemon has_gtk line
	has_daemon=$(${EMACS} ${EMACSFLAGS} --eval "(princ (fboundp 'daemonp))")
	has_gtk=$(${EMACS} ${EMACSFLAGS} --eval "(princ (featurep 'gtk))")

	if [[ ${has_daemon} != t ]]; then
		while read line; do ewarn "${line}"; done <<-EOF
		Your current Emacs version does not support running as a daemon which
		is required for ${CATEGORY}/${PN}.
		Use "eselect emacs" to select an Emacs version >= 23.
		EOF
	elif [[ ${has_gtk} == t ]]; then
		while read line; do ewarn "${line}"; done <<-EOF
		Your current Emacs is compiled with GTK+. There is a long-standing bug
		in GTK+ that prevents Emacs from recovering from X disconnects:
		<https://gitlab.gnome.org/GNOME/gtk/-/issues/221> and
		<https://gitlab.gnome.org/GNOME/gtk/-/issues/2315>.
		If you run Emacs as a daemon, then it is strongly recommended that you
		compile it with the Lucid or the Motif toolkit instead, i.e. with
		USE="athena Xaw3d -gtk -motif" or USE="motif -gtk -athena -Xaw3d".
		EOF
	fi
}

src_compile() { :; }

src_install() {
	newinitd emacs.rc emacs
	newconfd emacs.conf emacs
	dodoc README ChangeLog
}
