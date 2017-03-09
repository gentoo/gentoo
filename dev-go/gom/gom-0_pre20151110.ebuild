# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
EGO_PN=github.com/mattn/gom

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	EGIT_COMMIT=c522e7d
	ARCHIVE_URI="https://github.com/mattn/gom/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go Dependency management system similar to bundle for ruby"
HOMEPAGE="https://github.com/mattn/gom"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-colortext:="
RDEPEND=""

src_install() {
dobin gom
dodoc src/${EGO_PN}/README.mkd
}
