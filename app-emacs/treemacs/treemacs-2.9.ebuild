# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="26.1"

PYTHON_COMPAT=( python3_9 )

inherit elisp python-single-r1

DESCRIPTION="A tree layout file explorer for Emacs"
HOMEPAGE="https://github.com/Alexander-Miller/treemacs"
SRC_URI="https://github.com/Alexander-Miller/treemacs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="evil magit icons-dired"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# TODO: extra flags that need packages not yet in gentoo
# all-the-icons: app-emacs/all-the-icons
# persp:         app-emacs/persp
# perspective:   app-emacs/perspective
# projectile:    app-emacs/projectile

RDEPEND="${PYTHON_DEPS}
	>=app-emacs/ace-window-0.10.0_p20200706
	>=app-emacs/ht-2.3
	>=app-emacs/hydra-0.15.0
	>=app-emacs/pfuture-1.9
	>=app-emacs/cfrs-1.3.2
	evil? ( app-emacs/evil )
	magit? ( app-emacs/magit )"
DEPEND="${RDEPEND}"

RESTRICT="test" # test requires cask and buttercup.el which is not packaged
SITEFILE="50treemacs-gentoo.el"
DOCS=( README.org Changelog.org Extensions.org )

src_unpack() {
	elisp_src_unpack
	mv "${S}"/src/{elisp,scripts}/* "${S}/" || die

	if use evil; then
		mv "${S}/src/extra/treemacs-evil.el" "${S}/" || die
	fi

	if use magit; then
		mv "${S}/src/extra/treemacs-magit.el" "${S}/" || die
	fi

	if use icons-dired; then
		mv "${S}/src/extra/treemacs-icons-dired.el" "${S}/" || die
	fi
}

src_compile() {
	elisp-make-autoload-file "${S}/${PN}-autoload.el" "${S}/"
	elisp_src_compile
}

src_install() {
	elisp_src_install

	dodir "/usr/share/${PN}/"
	dodir "/usr/share/${PN}/icons"
	insinto "/usr/share/${PN}/icons/"
	doins -r "${S}/icons/default"
	dosym \
		"${EPREFIX}/usr/share/${PN}/icons" \
		"${EPREFIX}/${SITELISP}/${PN}/icons"
	insinto "${SITELISP}/${PN}/"
	doins "${S}"/*.py
}
