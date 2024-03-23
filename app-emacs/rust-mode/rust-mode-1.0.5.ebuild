# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A major emacs mode for editing Rust source code"
HOMEPAGE="https://github.com/rust-lang/rust-mode"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rust-lang/${PN}.git"
else
	SRC_URI="https://github.com/rust-lang/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -l ${PN}-tests.el
