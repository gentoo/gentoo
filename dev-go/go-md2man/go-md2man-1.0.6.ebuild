# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/cpuguy83/go-md2man

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64 ~arm ~arm64"
	EGIT_COMMIT=v${PV}
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="A utility to convert markdown to man pages"
HOMEPAGE="https://github.com/cpuguy83/go-md2man"
LICENSE="MIT"
SLOT="0"
IUSE=""
DEPEND="dev-go/blackfriday"
RDEPEND="dev-go/blackfriday:="

src_install() {
	"${S}"/go-md2man -in src/${EGO_PN}/go-md2man.1.md -out go-md2man.1
	dobin go-md2man
	doman go-md2man.1
}
