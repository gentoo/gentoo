# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Fast Web log analyzer using probabilistic data structures"
HOMEPAGE="https://www.logswan.org/
	https://github.com/fcambus/logswan/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fcambus/${PN}"
else
	SRC_URI="https://github.com/fcambus/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0"

RDEPEND="
	dev-libs/jansson:=
	dev-libs/libmaxminddb:=
"
DEPEND="
	${RDEPEND}
"
