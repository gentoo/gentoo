# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "gopkg.in/yaml.v2 eb3733d160e7 github.com/go-yaml/yaml" )

inherit golang-build golang-vcs-snapshot user

EGO_PN="github.com/genuinetools/reg"
GIT_COMMIT="4203e559f331009df04a3ca47820989c6c43e138"
ARCHIVE_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
KEYWORDS="~amd64"

DESCRIPTION="Docker registry v2 command line client"
HOMEPAGE="https://github.com/genuinetools/reg"
SRC_URI="${ARCHIVE_URI}"
LICENSE="MIT Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC"
SLOT="0"
IUSE=""

RESTRICT="test"

pkg_setup() {
	enewgroup reg
	enewuser reg -1 -1 /var/lib/reg reg
}

src_prepare() {
	pushd src/${EGO_PN} || die
	eapply "${FILESDIR}"/reg-0.16.0-config.patch
	default
	popd || die
}

src_compile() {
	export -n GOCACHE GOPATH XDG_CACHE_HOME
	pushd src/${EGO_PN} || die
	GO111MODULE=on go build -mod=vendor -v -ldflags "-X ${EGO_PN}/version.GITCOMMIT=${GIT_COMMIT} -X ${EGO_PN}/version.VERSION=${PV}" -o "${S}"/bin/reg . || die
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
