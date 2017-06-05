# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/Netflix-Skunkworks/go-jira"

EGO_VENDOR=(
	"github.com/coryb/optigo 6f3f720fe67b838bea7a8f53d9bcb58293daf590"
	"github.com/howeyc/gopass bf9dde6d0d2c004a008c27aaee91170c786f6db8"
	"github.com/kballard/go-shellquote d8ec1a69a250a17bb0e419c386eac1f3711dc142"
	"github.com/mgutz/ansi 9520e82c474b0a04dd04f8a40959027271bab992"
	"github.com/mattn/go-colorable ded68f7a9561c023e790de24279db7ebf473ea80"
	"github.com/tmc/keyring 39227cc0349f1b69956c23aa1f679eefd17ebae0"
	"github.com/guelfey/go.dbus f6a3a2366cc39b8479cadc499d3c735fb10fbdda"
	"gopkg.in/coryb/yaml.v2 c82a3f4d49697aad482124182e538657091c9364 github.com/coryb/yaml"
	"gopkg.in/op/go-logging.v1 b2cb9fa56473e98db8caba80237377e83fe44db5 github.com/op/go-logging"
	"golang.org/x/crypto e1a4589e7d3ea14a3352255d04b6f1a418845e5e github.com/golang/crypto"
)
inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A simple JIRA commandline client in Go"
HOMEPAGE="https://github.com/Netflix-Skunkworks/go-jira"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

src_prepare() {
	default
	pushd src/${EGO_PN} || die
	mkdir -p vendor/gopkg.in/Netflix-Skunkworks || die
	ln -sf '../../..' vendor/gopkg.in/Netflix-Skunkworks/go-jira.v0 || die
	popd || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${WORKDIR}/${P}" go build -v -o jira -ldflags "-X jira.VERSION=${PV} -w" main/main.go || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/jira
	dodoc src/${EGO_PN}/{CHANGELOG,README}.md
}
