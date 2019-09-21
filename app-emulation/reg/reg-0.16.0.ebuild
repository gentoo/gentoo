# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot user

EGO_PN="github.com/genuinetools/reg"
GIT_COMMIT="4a4d0e5d108ca9558879bdf1aba94d09e921cf1e"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Docker registry v2 command line client"
HOMEPAGE="https://github.com/genuinetools/reg"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT"
SLOT="0"
IUSE=""

RESTRICT="test"

pkg_setup() {
	enewgroup reg
	enewuser reg -1 -1 /var/lib/reg reg
}

src_prepare() {
	pushd src/${EGO_PN} || die
	default
	popd || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go build -v -ldflags "-X ${EGO_PN}/version.GITCOMMIT=${GIT_COMMIT} -X ${EGO_PN}/version.VERSION=${PV}" -o "${S}"/bin/reg . || die
	popd || die
}

src_install() {
	dobin bin/*
	dodoc src/${EGO_PN}/README.md
	insinto /var/lib/${PN}
	doins -r src/${EGO_PN}/server/*
	newinitd "${FILESDIR}"/reg.initd reg
	newconfd "${FILESDIR}"/reg.confd reg

	keepdir /var/log/reg
	fowners -R reg:reg /var/log/reg /var/lib/reg/static
}
