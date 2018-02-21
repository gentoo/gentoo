# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/BurntSushi/toml b26d9c308763d68093482582cea63d69be07a0f0"
	"github.com/chzyer/readline 41eea22f717c616615e1e59aa06cf831f9901f35"
	"github.com/fatih/color 9131ab34cf20d2f6d83fdc67168a5430d1c7dc23"
	"github.com/google/go-github 2966f2579cd93bc62410f55ba6830b3925e7629d"
	"github.com/google/go-querystring 53e6ce116135b80d037921a7fdd5138cf32d7a8a"
	"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
	"github.com/jroimartin/gocui ba396278de0a3c63658bbaba13d2d2fa392edb11"
	"github.com/mattn/go-colorable 5411d3eea5978e6cdc258b30de592b60df6aba96"
	"github.com/mattn/go-isatty 57fdcb988a5c543893cc61bce354a6e24ab70022"
	"github.com/mattn/go-runewidth 9e777a8366cce605130a531d2cd6363d07ad7317"
	"github.com/nsf/termbox-go b6acae516ace002cb8105a89024544a1480655a5"
	"github.com/spf13/cobra 63121c8814fc0b99184dbc1c8b7ef4fddae437c3"
	"github.com/spf13/pflag 2300d0f8576fe575f71aaa5b9bbe4e1b0dc2eb51"
	"google.golang.org/appengine 170382fa85b10b94728989dfcf6cc818b335c952 github.com/golang/appengine" )

EGO_PN="github.com/knqyf263/${PN}"

inherit golang-build golang-vcs-snapshot

ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Simple command-line snippet manager"
HOMEPAGE="https://github.com/knqyf263/pet"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="zsh-completion"

# dev-go/toml doesn't provide sources
DEPEND="dev-go/go-crypto
	dev-go/go-net
	dev-go/go-oauth2
	dev-go/go-protobuf
	dev-go/go-sys"
RDEPEND="${DEPEND}
	zsh-completion? ( app-shells/zsh-completions )"

src_install() {
	dobin pet

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins src/github.com/knqyf263/pet/misc/completions/zsh/_${PN}
	fi
}

pkg_postinstall() {
	einfo "You should consider to install app-shells/peco to be able to use selector command"
}
