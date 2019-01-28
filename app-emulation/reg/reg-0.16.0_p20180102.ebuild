# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "gopkg.in/yaml.v2 a3f3340b5840cee44f372bddb5880fcbc419b46a github.com/go-yaml/yaml" )

inherit golang-build golang-vcs-snapshot user

EGO_PN="github.com/genuinetools/reg"
GIT_COMMIT="d959057b30da67d5f162790f9d5b5160686901fd"
ARCHIVE_URI="https://${EGO_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"
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
	eapply "${FILESDIR}"/reg-0.16.0-config.patch
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
