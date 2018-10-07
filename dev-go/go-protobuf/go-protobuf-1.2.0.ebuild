# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_SRC="github.com/golang/protobuf"
EGO_PN=${EGO_SRC}/...
EGO_VENDOR=(
	"google.golang.org/genproto af9cb2a35e7f169ec875002c1829c9b315cddc04 github.com/google/go-genproto"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Go support for Google's protocol buffers"
HOMEPAGE="https://github.com/golang/protobuf"
SRC_URI="https://${EGO_SRC}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
LICENSE="BSD"
SLOT="0/${PVR}"
KEYWORDS="~amd64"
IUSE=""
DEPEND=""
RDEPEND=""

src_install() {
	rm -rf src/${EGO_SRC}/.git* || die
	golang-build_src_install
	rm -rf "${D}/usr/lib/go-gentoo/src/github.com/golang/protobuf/vendor" || die

	dobin bin/*
}
