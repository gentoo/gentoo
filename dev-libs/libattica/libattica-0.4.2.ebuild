# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="${P#lib}"
MY_PN="${PN#lib}"

if [[ $PV = *9999* ]]; then
	EGIT_REPO_URI="git://anongit.kde.org/attica"
	KEYWORDS=""
	scm_eclass=git-2
else
	SRC_URI="mirror://kde/stable/${MY_PN}/${MY_P}.tar.bz2"
	KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
fi

inherit cmake-utils ${scm_eclass}

DESCRIPTION="A library providing access to Open Collaboration Services"
HOMEPAGE="https://www.kde.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="debug test"

RDEPEND="
	dev-qt/qtcore:4
"
DEPEND="${RDEPEND}
	test? (
		dev-qt/qtgui:4
		dev-qt/qttest:4
	)
"

DOCS=( AUTHORS ChangeLog README )

S=${WORKDIR}/${MY_P}

src_configure() {
	local mycmakeargs=(
		-DQT4_BUILD=true
		$(cmake-utils_use test ATTICA_ENABLE_TESTS)
	)
	cmake-utils_src_configure
}
