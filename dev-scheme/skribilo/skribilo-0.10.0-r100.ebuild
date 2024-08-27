# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit elisp-common guile

DESCRIPTION="Document production tool written in Guile Scheme"
HOMEPAGE="https://www.nongnu.org/skribilo/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="
	app-text/ghostscript-gpl
	media-gfx/imagemagick

	${GUILE_DEPS}
	>=dev-scheme/guile-lib-0.2.7-r100[${GUILE_USEDEP}]
	>=dev-scheme/guile-reader-0.6.3-r100[${GUILE_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="emacs? ( >=app-editors/emacs-23.1:* )"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	# gnustep-base/gnustep-base installs /usr/bin/pl that isnt the unpackaged ploticus.
	sed -i -e 's/for ac_prog in ploticus pl/for ac_prog in ploticus/' configure || die
}

src_configure() {
	if ! use emacs ; then
		export EMACS="no"
		export EMACSLOADPATH="/dev/null"
	fi

	guile_foreach_impl econf
}

src_compile() {
	guile_src_compile

	use emacs && elisp-compile ./emacs/*.el
}

src_install() {
	guile_src_install

	# Link includes DESTDIR
	for file in ${ED}/usr/share/info/*.png; do
		rm "${file}" || die
		dosym ../doc/${PF}/html/$(basename ${file}) ${file##${ED}}
	done

	if use emacs ; then
		elisp-install ${PN} ./emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	else
		local emacsd="${D}"/usr/share/emacs
		if [[ -d "${emacsd}" ]] ; then
			einfo "Building without Emacs support but ${emacsd} found! Removing."
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
