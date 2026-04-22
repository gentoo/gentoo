# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major modes for MATLAB .m and .tlc files"
HOMEPAGE="https://github.com/mathworks/Emacs-MATLAB-Mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/mathworks/Emacs-MATLAB-Mode"
else
	SRC_URI="https://github.com/mathworks/Emacs-MATLAB-Mode/archive/refs/tags/${PN}-mode-${PV}.tar.gz
	   -> ${P}.gh.tar.gz"
	S="${WORKDIR}/Emacs-MATLAB-Mode-${PN}-mode-${PV}"

	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( NEWS.org README.org SECURITY.md )
SITEFILE="50${PN}-gentoo-3.3.6.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file matlab-load.el
}
