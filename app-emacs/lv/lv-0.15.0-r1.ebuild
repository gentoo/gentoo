# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Other echo area"
HOMEPAGE="https://github.com/abo-abo/hydra/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/abo-abo/hydra.git"
else
	SRC_URI="https://github.com/abo-abo/hydra/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/hydra-${PV}"
	KEYWORDS="amd64 ~arm64"
fi

LICENSE="GPL-3+"
SLOT="0"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile lv.el
}

src_install() {
	elisp-install lv lv.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
