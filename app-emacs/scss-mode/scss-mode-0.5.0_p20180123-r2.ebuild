# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="cf58dbec5394280503eb5502938f3b5445d1b53d"

inherit elisp

DESCRIPTION="Major mode for editing SCSS files in Emacs"
HOMEPAGE="https://github.com/antonj/scss-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/antonj/${PN}"
else
	SRC_URI="https://github.com/antonj/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	dev-ruby/sass
"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
