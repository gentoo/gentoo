# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == "0.6.1" ]] && COMMIT="5ea8f32ef50ce2b444d6918e17eedce9f74629af"

inherit elisp

DESCRIPTION="Persist variables between Emacs sessions"
HOMEPAGE="https://elpa.gnu.org/packages/persist.html"
SRC_URI="https://git.savannah.gnu.org/gitweb/?p=emacs/elpa.git;a=snapshot;h=${COMMIT};sf=tgz
	-> ${P}.tar.gz"
S="${WORKDIR}/elpa-${COMMIT:0:7}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# ELISP_TEXINFO="${PN}.texi"    # Broken.
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert test -l test/persist-tests.el

src_prepare() {
	default

	# Skip failing tests. Tests are marked as "WORK IN PROGRESS" at the
	# top of the file.
	local -a skip_tests=(
		test-persist-save-hash
	)
	local skip_test=""
	for skip_test in "${skip_tests[@]}"; do
		sed -i "/${skip_test}/a (ert-skip nil)" test/persist-tests.el || die
	done
}
