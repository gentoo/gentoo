# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/emacspeak/emacspeak-9999.ebuild,v 1.10 2015/03/10 15:29:50 williamh Exp $

EAPI=5

NEED_EMACS=24
FORCE_PRINT_ELOG=1
DISABLE_AUTOFORMATTING=1
inherit eutils readme.gentoo elisp

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/tvraman/emacspeak.git"
	inherit git-r3
else
	SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

DESCRIPTION="the emacspeak audio desktop"
HOMEPAGE="http://emacspeak.sourceforge.net/"
LICENSE="BSD GPL-2"
SLOT="0"
IUSE="+espeak"

	DEPEND="espeak? ( app-accessibility/espeak )"

RDEPEND="${DEPEND}
	>=dev-tcltk/tclx-8.4"

DOC_CONTENTS='
As of version 39.0 and later, the /usr/bin/emacspeak
shell script has been removed downstream in Gentoo.
You should launch emacspeak by another method, for instance
by adding the following to your ~/.emacs file:
(load "/usr/share/emacs/site-lisp/emacspeak/lisp/emacspeak-setup.el")
'

src_prepare() {
	# Allow user patches to be applied without modifying the ebuild
	epatch_user
}

src_configure() {
	emake config
}

src_compile() {
	emake emacspeak
	if use espeak; then
		local tcl_version="$(echo 'puts $tcl_version;exit 0' |tclsh)"
		if [[ -z $tcl_version ]]; then
			die 'Unable to detect the installed version of dev-lang/tcl.'
		fi
		cd servers/linux-espeak
		emake TCL_VERSION="${tcl_version}"
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	rm "${D}/usr/bin/emacspeak"
	if use espeak; then
		pushd servers/linux-espeak > /dev/null || die
		emake DESTDIR="${D}" install
		local orig_serverdir="/usr/share/emacs/site-lisp/emacspeak/servers/linux-espeak"
		local serverfile="${D}${orig_serverdir}/tclespeak.so"
		install -Dm755  "$serverfile" \
			"${D}/usr/$(get_libdir)/emacspeak/tclespeak.so" || die
		rm -f "$serverfile" || die
		dosym "/usr/$(get_libdir)/emacspeak/tclespeak.so" \
			"$orig_serverdir/tclespeak.so"
		popd > /dev/null || die
	fi
	dodoc README etc/NEWS* etc/FAQ etc/COPYRIGHT
	dohtml -r install-guide user-guide
	cd "${D}/usr/share/emacs/site-lisp/${PN}"
	rm -rf README etc/NEWS* etc/FAQ etc/COPYRIGHT install-guide \
		user-guide || die
	readme.gentoo_create_doc
}
