# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Alternative to isearch that uses ivy to show overview of all matches"
HOMEPAGE="https://github.com/abo-abo/swiper/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/abo-abo/swiper"
else
	SRC_URI="https://github.com/abo-abo/swiper/archive/${PV}.tar.gz
		-> swiper-${PV}.gh.tar.gz"
	S="${WORKDIR}/swiper-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"  # Ivy, Swiper and Counsel tests are performed in "app-emacs/ivy".

RDEPEND="
	>=app-emacs/ivy-${PV}
"
BDEPEND="
	${RDEPEND}
"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile "${PN}.el"
}

src_test() {
	:
}

src_install() {
	elisp-install "${PN}" "${PN}.el"{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
