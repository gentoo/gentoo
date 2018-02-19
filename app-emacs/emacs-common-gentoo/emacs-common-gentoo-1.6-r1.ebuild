# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp-common eutils xdg-utils gnome2-utils readme.gentoo-r1 user

DESCRIPTION="Common files needed by all GNU Emacs versions"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="games X"

PDEPEND="virtual/emacs"

pkg_setup() {
	use games && enewgroup gamestat 36
}

src_install() {
	insinto "${SITELISP}"
	doins subdirs.el
	newins site-gentoo.el{,.orig}

	keepdir /etc/emacs
	insinto /etc/emacs
	doins site-start.el

	if use games; then
		keepdir /var/games/emacs
		fowners 0:gamestat /var/games/emacs
		fperms g+w /var/games/emacs
	fi

	if use X; then
		local i
		domenu emacs.desktop emacsclient.desktop || die

		pushd icons || die
		newicon sink.png emacs-sink.png
		newicon emacs25_48.png emacs.png
		for i in 16 24 32 48 128; do
			[[ ${i} -le 48 ]] && newicon -s ${i} emacs22_${i}.png emacs22.png
			newicon -s ${i} emacs23_${i}.png emacs23.png
			newicon -s ${i} emacs25_${i}.png emacs.png
		done
		doicon -s scalable emacs23.svg
		newicon -s scalable emacs25.svg emacs.svg
		popd

		gnome2_icon_savelist
	fi

	DOC_CONTENTS="All site initialisation for Gentoo-installed packages is
		added to ${SITELISP}/site-gentoo.el. In order for this site
		initialisation to be loaded for all users automatically, a default
		site startup file /etc/emacs/site-start.el is installed. You are
		responsible for maintenance of this file.
		\n\nAlternatively, individual users can add the following command:
		\n\n(require 'site-gentoo)
		\n\nto their ~/.emacs initialisation files, or, for greater
		flexibility, users may load single package-specific initialisation
		files from the ${SITELISP}/site-gentoo.d/ directory."
	readme.gentoo_create_doc
}

pkg_preinst() {
	# make sure that site-gentoo.el exists since site-start.el requires it
	if [[ ! -f ${ED}${SITELISP}/site-gentoo.el ]]; then		#554518
		mv "${ED}${SITELISP}"/site-gentoo.el{.orig,} || die
	fi
	if [[ -d ${EROOT}${SITELISP} ]]; then
		elisp-site-regen
		cp "${EROOT}${SITELISP}/site-gentoo.el" "${ED}${SITELISP}/" || die
	fi

	if use games; then
		local f
		for f in /var/games/emacs/{snake,tetris}-scores; do
			if [[ -e ${EROOT}${f} ]]; then
				cp "${EROOT}${f}" "${ED}${f}" || die
			fi
			touch "${ED}${f}" || die
			chgrp gamestat "${ED}${f}" || die
			chmod g+w "${ED}${f}" || die
		done
	fi
}

pkg_postinst() {
	if use X; then
		xdg_desktop_database_update
		gnome2_icon_cache_update
	fi
	readme.gentoo_print_elog
}

pkg_postrm() {
	if use X; then
		xdg_desktop_database_update
		gnome2_icon_cache_update
	fi
}
