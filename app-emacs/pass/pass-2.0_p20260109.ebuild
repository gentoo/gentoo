# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

COMMIT="de4adfaeba5eb4d1facaf75f582f1ba36373299a"
DESCRIPTION="Major mode for password-store"
HOMEPAGE="https://github.com/NicolasPetton/pass"
SRC_URI="https://github.com/NicolasPetton/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-admin/pass[emacs]
	app-emacs/f
	app-emacs/password-store-otp"
BDEPEND="${RDEPEND}"

DOCS=( README.md CONTRIBUTING.md )
SITEFILE="60${PN}-gentoo.el"
