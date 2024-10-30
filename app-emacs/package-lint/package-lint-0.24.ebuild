# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Linting library for Emacs Lisp package metadata"
HOMEPAGE="https://github.com/purcell/package-lint/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/purcell/${PN}.git"
else
	SRC_URI="https://github.com/purcell/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/compat
"
BDEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-0.22-load-data-directory.patch"
)

SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i "${PN}.el" || die

	# Skip failing test. Tests are marked as "WORK IN PROGRESS" at the
	# top of the file.
	local -a skip_tests=(
		package-lint-test-accept-new-backported-libraries-with-backport-dep
		package-lint-test-accept-new-backported-sub-libraries-with-backport-dep
		package-lint-test-accept-normal-deps
		package-lint-test-accepts-new-backported-functions-with-backport-dep
		package-lint-test-accepts-new-functions-with-compat
		package-lint-test-accepts-new-macros-with-compat
		package-lint-test-error-new-backported-sub-libraries
		package-lint-test-warn-unversioned-dep
	)
	local skip_test=""
	for skip_test in "${skip_tests[@]}"; do
		sed -i "/${skip_test}/a (ert-skip nil)" package-lint-test.el || die
	done
}

src_install() {
	elisp-install "${PN}" ${PN}{,-flymake}.el{,c}
	elisp-make-site-file "${SITEFILE}"

	insinto "${SITEETC}/${PN}"
	doins -r data

	einstalldocs
}
