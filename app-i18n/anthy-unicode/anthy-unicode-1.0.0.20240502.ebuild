# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common

DESCRIPTION="Another Anthy - Japanese character set input library for Unicode"
HOMEPAGE="https://github.com/fujiwarat/anthy-unicode"
SRC_URI="https://github.com/fujiwarat/anthy-unicode/archive/${PV}.tar.gz -> ${P}.tar.gz"

# GPL-2+ for dictionaries
LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="emacs"

DEPEND="
	emacs? ( app-editors/emacs:* )
"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	use emacs && elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst(){
	use emacs && elisp-site-regen
}

pkg_postrm(){
	use emacs && elisp-site-regen
}
