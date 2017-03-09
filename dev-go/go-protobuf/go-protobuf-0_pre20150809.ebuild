# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGO_SRC=github.com/golang/protobuf
EGO_PN=${EGO_SRC}/...

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="68c687dc49948540b356a6b47931c9be4fcd0245"
	SRC_URI="https://${EGO_SRC}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go support for Google's protocol buffers"
HOMEPAGE="https://${EGO_SRC}"
LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	rm -rf src/${EGO_SRC}/.git* || die
	golang-build_src_install
	dobin bin/*
}
