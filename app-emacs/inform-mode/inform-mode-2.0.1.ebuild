# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A major mode for editing Inform programs"
HOMEPAGE="https://rrthomas.github.io/inform-mode/
	https://github.com/rrthomas/inform-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/rrthomas/${PN}"
else
	SRC_URI="https://github.com/rrthomas/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ppc sparc x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( AUTHORS README.md )
SITEFILE="50${PN}-gentoo.el"
