# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit bash-completion-r1 golang-vcs-snapshot

KEYWORDS="~amd64"
DESCRIPTION="A tool that facilitates building OCI images"
HOMEPAGE="https://github.com/projectatomic/buildah"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
EGO_PN="${HOMEPAGE#*//}"
EGIT_COMMIT="v${PV}"
GIT_COMMIT="1ab80bc"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RDEPEND="app-crypt/gpgme:=
	app-emulation/skopeo
	dev-libs/libgpg-error:=
	dev-libs/libassuan:=
	sys-fs/lvm2:=
	sys-libs/libseccomp:="
DEPEND="${RDEPEND}"
RESTRICT="test"
S="${WORKDIR}/${P}/src/${EGO_PN}"

src_prepare() {
	default
	sed -e 's|^\(GIT_COMMIT := \).*|\1'${GIT_COMMIT}'|' -i Makefile || die
}

src_compile() {
	GOPATH="${WORKDIR}/${P}" emake all
}

src_install() {
	dodoc README.md
	doman docs/*.1
	dodoc -r docs/tutorials
	dobin ${PN} imgtype
	dobashcomp contrib/completions/bash/buildah
}

src_test() {
	GOPATH="${WORKDIR}/${P}" emake test-unit
}
