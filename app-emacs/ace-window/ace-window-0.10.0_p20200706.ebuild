# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="24.1"

inherit elisp

DESCRIPTION="GNU Emacs package for selecting a window to switch to"
HOMEPAGE="https://github.com/abo-abo/ace-window"
# Last github release is from 2015 which is extremely outdated.
# This snapshot is from 2020 and also is what melpa stable tracks.
COMMIT="c7cb315c14e36fded5ac4096e158497ae974bec9"
SRC_URI="https://github.com/abo-abo/ace-window/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # Barely useful test that requires internet access

RDEPEND=">=app-emacs/avy-0.5.0"
DEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"
DOCS=( README.md )

src_compile() {
	elisp-make-autoload-file "${S}/${PN}-autoload.el" "${S}/"
	elisp_src_compile
}
