# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_VENDOR=( 
	"github.com/BurntSushi/toml b26d9c308763d68093482582cea63d69be07a0f0"
	"github.com/briandowns/spinner 48dbb65d7bd5c74ab50d53d04c949f20e3d14944"
	"github.com/chzyer/readline 2972be24d48e78746da79ba8e24e8b488c9880de"
	"github.com/fatih/color 5b77d2a35fb0ede96d138fc9a99f5c9b6aef11b4"
	"github.com/google/go-github e48060a28fac52d0f1cb758bc8b87c07bac4a87d"
	"github.com/xanzy/go-gitlab 26ea551e8c159cea42a9f206bc18ae5884d44d0c"
	"github.com/google/go-querystring 53e6ce116135b80d037921a7fdd5138cf32d7a8a"
	"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
	"github.com/jroimartin/gocui c055c87ae801372cd74a0839b972db4f7697ae5f"
	"github.com/mattn/go-colorable 167de6bfdfba052fa6b2d3664c8f5272e23c9072"
	"github.com/mattn/go-isatty 0360b2af4f38e8d38c7fce2a9f4e702702d73a39"
	"github.com/mattn/go-runewidth 9e777a8366cce605130a531d2cd6363d07ad7317"
	"github.com/nsf/termbox-go 21a4d435a86280a2927985fd6296de56cbce453e"
	"github.com/pkg/errors 645ef00459ed84a119197bfb8d8205042c6df63d"
	"github.com/spf13/cobra ef82de70bb3f60c65fb8eebacbb2d122ef517385"
	"github.com/spf13/pflag 583c0c0531f06d5278b7d917446061adc344b5cd"
	"google.golang.org/appengine 150dc57a1b433e64154302bdc40b6bb8aefa313a github.com/golang/appengine"
)

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
DEPEND="
	dev-go/go-crypto:=
	dev-go/go-net:=
	dev-go/go-oauth2:=
	dev-go/go-protobuf:=
	dev-go/go-sys:="

RDEPEND="
	${DEPEND}
	zsh-completion? ( app-shells/zsh-completions )"

src_install() {
	dobin pet

	if use zsh-completion; then
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
