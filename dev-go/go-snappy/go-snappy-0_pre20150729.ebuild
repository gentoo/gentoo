# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGO_SRC=github.com/golang/snappy
EGO_PN=${EGO_SRC}/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="723cc1e459b8eea2dea4583200fd60757d40097a"
	SRC_URI="https://${EGO_SRC}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="The Snappy compression format in the Go programming language."
HOMEPAGE="https://github.com/golang/snappy"
LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""
DEPEND=""
RDEPEND=""
