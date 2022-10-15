# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1
FORCE_PRINT_ELOG=1
DISABLE_AUTOFORMATTING=1
inherit elisp toolchain-funcs readme.gentoo-r1

DESCRIPTION="The emacspeak audio desktop"
HOMEPAGE="http://emacspeak.sourceforge.net/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/tvraman/emacspeak.git"
	inherit git-r3
else
	SRC_URI="https://github.com/tvraman/emacspeak/releases/download/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="+espeak"

# Usually need := dep with tcl anyway but in particular, it's needed
# here as we do a version check in src_compile and bake in the results.
DEPEND="
	dev-lang/tcl:=
	espeak? ( app-accessibility/espeak-ng )
"
RDEPEND="
	${DEPEND}
	>=dev-tcltk/tclx-8.4
"

DOC_CONTENTS='
As of version 39.0 and later, the /usr/bin/emacspeak
shell script has been removed downstream in Gentoo.
You should launch emacspeak by another method, for instance
by adding the following to your ~/.emacs file:
(load "/usr/share/emacs/site-lisp/emacspeak/lisp/emacspeak-setup.el")
'

HTML_DOCS=( etc/ info/ )

src_configure() {
	MAKEOPTS+=" -j1"

	tc-export CXX

	emake config
}

src_compile() {
	emake emacspeak
	if use espeak; then
		local tcl_version="$(echo 'puts $tcl_version;exit 0' |tclsh)"
		if [[ -z ${tcl_version} ]]; then
			die 'Unable to detect the installed version of dev-lang/tcl.'
		fi

		cd servers/native-espeak || die
		emake TCL_VERSION="${tcl_version}"
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	if use espeak; then
		pushd servers/native-espeak > /dev/null || die

		emake DESTDIR="${D}" install
		local orig_serverdir="/usr/share/emacs/site-lisp/emacspeak/servers/native-espeak"
		local serverfile="${ED}${orig_serverdir}/tclespeak.so"

		install -Dm755 "${serverfile}" \
			"${ED}/usr/$(get_libdir)/emacspeak/tclespeak.so" || die
		rm -f "${serverfile}" || die

		dosym -r "/usr/$(get_libdir)/emacspeak/tclespeak.so" \
			"${orig_serverdir}/tclespeak.so"
		popd > /dev/null || die
	fi

	dodoc README etc/NEWS* etc/COPYRIGHT
	einstalldocs

	cd "${ED}"/usr/share/emacs/site-lisp/${PN} || die
	rm -rf README etc/NEWS* etc/COPYRIGHT install-guide \
		user-guide || die
	readme.gentoo_create_doc
}
