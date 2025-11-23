# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp optfeature

DESCRIPTION="A project interaction library for Emacs"
HOMEPAGE="https://github.com/bbatsov/projectile/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/bbatsov/${PN}"
else
	SRC_URI="https://github.com/bbatsov/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50projectile-gentoo.el"

elisp-enable-tests buttercup test

src_test() {
	mkdir -p "${HOME}/.emacs.d" || die  # For "projectile--directory-p" test.

	elisp-test
}

pkg_postinst() {
	# Descriptions for this packages' purpose were taken from Projectile's
	# home page https://docs.projectile.mx/projectile/usage.html
	optfeature_header "Install the following packages for improved performance:"
	optfeature "super-fast alternative to find" sys-apps/fd
	optfeature "powerful alternative to grep" sys-apps/ripgrep
}
