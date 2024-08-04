# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=28.1

inherit elisp

DESCRIPTION="Simple notes for Emacs with an efficient file-naming scheme"
HOMEPAGE="https://protesilaos.com/emacs/denote/
	https://github.com/protesilaos/denote/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protesilaos/${PN}.git"
else
	SRC_URI="https://github.com/protesilaos/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( CHANGELOG.org README.md )
ELISP_TEXINFO="${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert tests

src_prepare() {
	default

	# Skip failing test. Tests are marked as "WORK IN PROGRESS" at the
	# top of the file.
	local skip_tests=(
		denote-test--denote-get-identifier
	)
	for test in "${skip_tests[@]}"; do
		sed -i "/${test}/a (ert-skip nil)" tests/denote-test.el || die
	done
}

src_compile() {
	elisp-org-export-to texinfo README.org
	elisp_src_compile
	elisp-make-autoload-file
}
