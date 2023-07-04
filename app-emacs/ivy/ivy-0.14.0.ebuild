# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Generic completion mechanism for Emacs"
HOMEPAGE="https://github.com/abo-abo/swiper/"
SRC_URI="https://github.com/abo-abo/swiper/archive/${PV}.tar.gz
	-> swiper-${PV}.tar.gz"
S="${WORKDIR}"/swiper-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="sys-apps/texinfo"

DOCS=( CONTRIBUTING.org README.md doc/{Changelog,ivy-help,ivy}.org )
SITEFILE="50${PN}-gentoo.el"

# Main Ivy sources. Swiper, Counsel and Ivy extensions have their own packages.
IVY_SOURCES=( colir.el ivy{,-overlay,-faces}.el )

src_prepare() {
	elisp_src_prepare

	# Wipe "elpa.el" to prevent initialization of the "package" library.
	[[ ! -f elpa.el ]] && die "no \"elpa.el\" found"
	echo "" > elpa.el || die "failed to wipe \"elpa.el\""
}

src_compile() {
	elisp-compile ${IVY_SOURCES[@]}
	emake -C doc ivy.info
}

src_test() {
	emake emacs="${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS}" test
}

src_install() {
	elisp-install ${PN} ${IVY_SOURCES[@]} *.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	doinfo doc/ivy.info
	einstalldocs
}
