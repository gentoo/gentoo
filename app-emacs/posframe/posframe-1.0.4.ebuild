# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="27"

inherit elisp

DESCRIPTION="Pop a postframe at point"
# The latest github release is out of date with the actual release.
# This snapshot is what melpa stable currently targets.
MY_COMMIT="74f06b77deeb770cd0a96977b1e6bdedb682487a"
HOMEPAGE="https://github.com/tumashu/posframe"
SRC_URI="https://github.com/tumashu/posframe/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-editors/emacs-27[gtk]"

SITEFILE="50${PN}-gentoo.el"
ELISP_REMOVE="posframe-benchmark.el"
DOCS=( README.org )

src_compile() {
	elisp-make-autoload-file "${S}/${PN}-autoload.el" "${S}/"
	elisp_src_compile
}
