# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Generic completion mechanism for Emacs"
HOMEPAGE="https://github.com/abo-abo/swiper/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/abo-abo/swiper"
else
	SRC_URI="https://github.com/abo-abo/swiper/archive/${PV}.tar.gz
		-> swiper-${PV}.gh.tar.gz"
	S="${WORKDIR}/swiper-${PV}"

	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-apps/texinfo
	test? (
		app-emacs/avy
		app-emacs/hydra
	)
"

PATCHES=( "${FILESDIR}/ivy-0.15.0-ivy-test.patch"  )

DOCS=( CONTRIBUTING.org README.md doc/{Changelog,ivy-help,ivy}.org )
SITEFILE="50${PN}-gentoo.el"

# Main Ivy sources. Swiper, Counsel and Ivy extensions have their own packages.
EL_SOURCES=( colir.el ivy{,-overlay,-faces}.el )

elisp-enable-tests ert .

src_prepare() {
	elisp_src_prepare

	# Wipe "elpa.el" to prevent initialization of the "package" library.
	echo "" > elpa.el || die "failed to wipe \"elpa.el\""
}

src_compile() {
	elisp-compile "${EL_SOURCES[@]}"

	emake -C doc ivy.info
}

src_install() {
	elisp-install "${PN}" "${EL_SOURCES[@]}" ./*.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	doinfo ./doc/ivy.info
	einstalldocs
}
