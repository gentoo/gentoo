# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( "github.com/BurntSushi/toml b26d9c308763d68093482582cea63d69be07a0f0"
	"github.com/briandowns/spinner 48dbb65d7bd5c74ab50d53d04c949f20e3d14944"
	"github.com/chzyer/readline f6d7a1f6fbf35bbf9beb80dc63c56a29dcfb759f"
	"github.com/fatih/color 570b54cabe6b8eb0bc2dfce68d964677d63b5260"
	"github.com/google/go-github e48060a28fac52d0f1cb758bc8b87c07bac4a87d"
	"github.com/google/go-querystring 53e6ce116135b80d037921a7fdd5138cf32d7a8a"
	"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
	"github.com/jroimartin/gocui 4f518eddb04b8f73870836b6d1941e8aa3c06637"
	"github.com/mattn/go-colorable 167de6bfdfba052fa6b2d3664c8f5272e23c9072"
	"github.com/mattn/go-isatty 0360b2af4f38e8d38c7fce2a9f4e702702d73a39"
	"github.com/mattn/go-runewidth 9e777a8366cce605130a531d2cd6363d07ad7317"
	"github.com/nsf/termbox-go 88b7b944be8bc8d8ec6195fca97c5869ba20f99d"
	"github.com/pkg/errors 645ef00459ed84a119197bfb8d8205042c6df63d"
	"github.com/spf13/cobra 7b2c5ac9fc04fc5efafb60700713d4fa609b777b"
	"github.com/spf13/pflag e57e3eeb33f795204c1ca35f56c44f83227c6e66"
	"google.golang.org/appengine 150dc57a1b433e64154302bdc40b6bb8aefa313a github.com/golang/appengine" )

EGO_PN="github.com/knqyf263/${PN}"

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Simple command-line snippet manager"
HOMEPAGE="https://github.com/knqyf263/pet"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="zsh-completion"

# dev-go/toml doesn't provide sources
DEPEND="dev-go/go-crypto:=
	dev-go/go-net:=
	dev-go/go-oauth2:=
	dev-go/go-protobuf:=
	dev-go/go-sys:="
RDEPEND="${DEPEND}
	zsh-completion? ( app-shells/zsh-completions )"

src_install() {
	dobin pet

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins src/github.com/knqyf263/pet/misc/completions/zsh/_pet
	fi
}

pkg_postinst() {
	if ! has_version app-shells/peco ; then
		einfo "You should consider to install app-shells/peco"
		einfo "to be able to use selector command"
	fi
}
