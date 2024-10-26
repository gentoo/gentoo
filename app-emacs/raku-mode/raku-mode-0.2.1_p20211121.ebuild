# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="977b14a7c1295ebf2aad2f807d3f8e7c27aeb47f"

inherit elisp

DESCRIPTION="Major mode for editing Raku code"
HOMEPAGE="https://github.com/Raku/raku-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/Raku/${PN}.git"
else
	SRC_URI="https://github.com/Raku/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( CHANGELOG.md README.md README.tmp-imenu-notes )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test
