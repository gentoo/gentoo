# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Versions of common Emacs commands customized to make the best use of ivy"
HOMEPAGE="https://github.com/abo-abo/swiper/"
SRC_URI="https://github.com/abo-abo/swiper/archive/${PV}.tar.gz
			-> swiper-${PV}.tar.gz"
S="${WORKDIR}"/swiper-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="test"  # Ivy, Swiper and Counsel tests are performed in app-emacs/ivy

RDEPEND="
	>=app-emacs/ivy-${PV}
	>=app-emacs/swiper-${PV}
"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile ${PN}.el
}

src_install() {
	elisp-install ${PN} ${PN}.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
