# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Show tooltip at point"
HOMEPAGE="https://github.com/pitkali/pos-tip/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pitkali/${PN}.git"
else
	SRC_URI="https://github.com/pitkali/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

SITEFILE="50${PN}-gentoo.el"
