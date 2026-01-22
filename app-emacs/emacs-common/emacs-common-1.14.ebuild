# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common desktop eapi9-pipestatus gnome2-utils readme.gentoo-r1

if [[ ${PV##*.} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/emacs-tools.git"
	EGIT_BRANCH="${PN}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}"
	S="${EGIT_CHECKOUT_DIR}"
else
	SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
fi

DESCRIPTION="Common files needed by all GNU Emacs versions"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="games gsettings gui"

DEPEND="games? ( acct-group/gamestat )"
RDEPEND="${DEPEND}
	!<app-emacs/emacs-daemon-0.25
	!<x11-misc/emacs-desktop-mail-1.3"
PDEPEND=">=app-editors/emacs-26.1:*"
IDEPEND="gui? ( gsettings? ( dev-libs/glib ) )"

SITEFILE="10${PN}-gentoo.el"

src_prepare() {
	default
	if [[ -n ${EPREFIX} ]]; then
		sed -i -E -e "s,/(bin|sbin|usr)/,${EPREFIX}&,g" \
			subdirs.el.in emacs.initd emacs.service \
			emacs.desktop emacsclient.desktop || die
	fi
}

src_install() {
	insinto "${SITELISP}"
	sed "s,@libdir@,$(get_libdir),g" subdirs.el.in | newins - subdirs.el
	pipestatus || die
	newins site-gentoo.el{,.orig}

	keepdir /etc/emacs
	insinto /etc/emacs
	doins site-start.el

	exeinto /etc/user/init.d
	newexe emacs.initd emacs
	exeinto /usr/libexec/emacs
	doexe emacs-wrapper.sh
	elisp-site-file-install "${SITEFILE}"

	# don't use systemd_douserunit because it would require inheriting
	# three eclasses (systemd pulls toolchain-funcs and multilib)
	insinto "/usr/lib/systemd/user"
	doins emacs.service

	if use games; then
		keepdir /var/games/emacs
		fowners 0:gamestat /var/games/emacs
		fperms g+w /var/games/emacs
	fi

	if use gui; then
		local i
		domenu emacs.desktop emacsclient.desktop \
			emacs-mail.desktop emacsclient-mail.desktop

		pushd icons >/dev/null || die
		newicon sink.png emacs-sink.png
		newicon emacs25_48.png emacs.png
		for i in 16 24 32 48 128; do
			[[ ${i} -le 48 ]] && newicon -s ${i} emacs22_${i}.png emacs22.png
			newicon -s ${i} emacs23_${i}.png emacs23.png
			newicon -s ${i} emacs25_${i}.png emacs.png
		done
		doicon -s scalable emacs23.svg
		newicon -s scalable emacs25.svg emacs.svg
		popd >/dev/null || die

		if use gsettings; then
			insinto /usr/share/glib-2.0/schemas
			doins org.gnu.emacs.defaults.gschema.xml
		fi
	fi

	dodoc README.daemon ChangeLog

	local DOC_CONTENTS DISABLE_AUTOFORMATTING=1
	DOC_CONTENTS=$(sed "s,@SITELISP@,${EPREFIX}${SITELISP},g" \
		README.gentoo.in) || die
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
	elisp-site-regen
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
		use gsettings && gnome2_schemas_update
	fi
	readme.gentoo_print_elog
}

pkg_postrm() {
	elisp-site-regen
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
		use gsettings && gnome2_schemas_update
	fi
}
