# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common

DESCRIPTION="Document production tool written in Guile Scheme"
HOMEPAGE="https://www.nongnu.org/skribilo/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"
RESTRICT="strip test"  # tests fail, seem broken

RDEPEND="
	app-text/ghostscript-gpl
	media-gfx/imagemagick

	>=dev-scheme/guile-2.0.0:=
	dev-scheme/guile-lib
	dev-scheme/guile-reader
"
DEPEND="${RDEPEND}"
BDEPEND="emacs? ( >=app-editors/emacs-23.1:* )"

# guile generates ELF files without use of C or machine code
# It's a portage's false positive. bug #677600
QA_PREBUILT='*[.]go'

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=38112
	find "${S}" -name "*.scm" -exec touch {} + || die
}

src_configure() {
	if ! use emacs ; then
		export EMACS="no"
		export EMACSLOADPATH="/dev/null"
	fi

	econf
}

src_compile() {
	default

	use emacs && elisp-compile ./emacs/*.el
}

src_install() {
	default

	if use emacs ; then
		elisp-install ${PN} ./emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	else
		local emacsd="${D}"/usr/share/emacs
		if [[ -d "${emacsd}" ]] ; then
			echo "Building without Emacs support but ${emacsd} found! Removing."
			rm -r "${emacsd}" || die
		fi
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
