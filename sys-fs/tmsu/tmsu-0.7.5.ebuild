# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/oniony/TMSU/"
EGO_VENDOR=( "github.com/mattn/go-sqlite3 v1.12.0" )

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Files tagger and virtual tag-based filesystem"
HOMEPAGE="https://github.com/oniony/TMSU/wiki"
SRC_URI="
	https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}
"

LICENSE="AGPL-3 AGPL-3+ BSD-4 GPL-3+ MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-fs/fuse:0"
DEPEND="
	dev-lang/go
	dev-libs/go-fuse
	test? ( ${RDEPEND} )
"

src_prepare() {
	default
	mkdir "${WORKDIR}/${P}/src/${EGO_PN}vendor/src" || die
	mv "${WORKDIR}/${P}/src/${EGO_PN}vendor/github.com" "${WORKDIR}/${P}/src/${EGO_PN}vendor/src/" || die
}

src_compile() {
	pushd "${WORKDIR}/${P}/src/${EGO_PN}" || die
		GOPATH="${WORKDIR}/${P}/src/${EGO_PN}vendor/" emake
	popd || die
}

src_test() {
	cd "${WORKDIR}/${P}/src/github.com/oniony/TMSU/tests" || die
	./runall || die
}

src_install() {
	dobin "${WORKDIR}/${P}/src/${EGO_PN}bin/tmsu"
	dobin  "${WORKDIR}/${P}/src/${EGO_PN}misc/bin/"*
	doman  "${WORKDIR}/${P}/src/${EGO_PN}misc/man/tmsu."*
	insinto /usr/share/zsh/site-functions
	doins "${WORKDIR}/${P}/src/${EGO_PN}misc/zsh/_tmsu"
}
