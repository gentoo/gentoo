# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == "1.27" ]] && COMMIT="a16e9d8b0952de1badf6da8e652b178a7f6c4498"

NEED_EMACS="27.1"

inherit elisp

DESCRIPTION="A major mode for editing comma-separated value files"
HOMEPAGE="https://elpa.gnu.org/packages/csv-mode.html
	https://www.emacswiki.org/emacs/CsvMode"
SRC_URI="https://git.savannah.gnu.org/gitweb/?p=emacs/elpa.git;a=snapshot;h=${COMMIT};sf=tgz
	-> ${P}.tar.gz"
S="${WORKDIR}/elpa-${COMMIT:0:7}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert . -l "${PN}-tests.el"

src_install() {
	rm csv-mode-tests.el{,c} || die

	elisp_src_install
}
