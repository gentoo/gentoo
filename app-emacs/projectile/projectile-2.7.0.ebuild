# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A project interaction library for Emacs"
HOMEPAGE="https://docs.projectile.mx
	https://github.com/bbatsov/projectile/"
SRC_URI="https://github.com/bbatsov/projectile/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

SITEFILE="50projectile-gentoo.el"
DOCS=( README.md )

elisp-enable-tests buttercup test

src_test() {
	mkdir -p "${HOME}"/.emacs.d || die  # For "projectile--directory-p" test

	elisp-test
}
