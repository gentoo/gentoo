# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=2c3233c0e09ef34176787b6e3da4319751ad91e7
NEED_EMACS=24

inherit elisp

DESCRIPTION="Compatibility libraries for Emacs"
HOMEPAGE="https://git.sr.ht/~pkal/compat/"
SRC_URI="https://git.sr.ht/~pkal/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-apps/texinfo
	test? ( >=app-editors/emacs-27.2[json] )
"

ELISP_TEXINFO="${PN}.texi"

src_compile() {
	emake compile ${PN}.info
}
