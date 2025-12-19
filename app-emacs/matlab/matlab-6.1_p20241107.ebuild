# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major modes for MATLAB .m and .tlc files"
HOMEPAGE="https://github.com/mathworks/Emacs-MATLAB-Mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/mathworks/Emacs-MATLAB-Mode"
else
	[[ "${PV}" == *p20241107 ]] && COMMIT="f13f511670a52cfa23c4f065a231a3e691763633"

	SRC_URI="https://github.com/mathworks/Emacs-MATLAB-Mode/archive/${COMMIT}.tar.gz
	   -> ${P}.gh.tar.gz"
	S="${WORKDIR}/Emacs-MATLAB-Mode-${COMMIT}"

	KEYWORDS="amd64 ~ppc x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS="README.org ChangeLog*"
SITEFILE="50${PN}-gentoo-3.3.6.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file matlab-load.el
}
