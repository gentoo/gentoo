# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Simple command-line snippet manager"
HOMEPAGE="https://github.com/knqyf263/pet"

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.0"
	"github.com/BurntSushi/toml v0.3.0/go.mod"
	"github.com/briandowns/spinner v0.0.0-20170614154858-48dbb65d7bd5"
	"github.com/briandowns/spinner v0.0.0-20170614154858-48dbb65d7bd5/go.mod"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e/go.mod"
	"github.com/fatih/color v1.7.0"
	"github.com/fatih/color v1.7.0/go.mod"
	"github.com/golang/protobuf v1.1.0"
	"github.com/golang/protobuf v1.1.0/go.mod"
	"github.com/google/go-github v15.0.0+incompatible"
	"github.com/google/go-github v15.0.0+incompatible/go.mod"
	"github.com/google/go-querystring v0.0.0-20170111101155-53e6ce116135"
	"github.com/google/go-querystring v0.0.0-20170111101155-53e6ce116135/go.mod"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
	"github.com/jroimartin/gocui v0.4.0"
	"github.com/jroimartin/gocui v0.4.0/go.mod"
	"github.com/mattn/go-colorable v0.0.9"
	"github.com/mattn/go-colorable v0.0.9/go.mod"
	"github.com/mattn/go-isatty v0.0.3"
	"github.com/mattn/go-isatty v0.0.3/go.mod"
	"github.com/mattn/go-runewidth v0.0.2"
	"github.com/mattn/go-runewidth v0.0.2/go.mod"
	"github.com/nsf/termbox-go v0.0.0-20180509163535-21a4d435a862"
	"github.com/nsf/termbox-go v0.0.0-20180509163535-21a4d435a862/go.mod"
	"github.com/pkg/errors v0.8.0"
	"github.com/pkg/errors v0.8.0/go.mod"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/cobra v0.0.3/go.mod"
	"github.com/spf13/pflag v1.0.1"
	"github.com/spf13/pflag v1.0.1/go.mod"
	"github.com/xanzy/go-gitlab v0.10.5"
	"github.com/xanzy/go-gitlab v0.10.5/go.mod"
	"golang.org/x/crypto v0.0.0-20180608092829-8ac0e0d97ce4"
	"golang.org/x/crypto v0.0.0-20180608092829-8ac0e0d97ce4/go.mod"
	"golang.org/x/net v0.0.0-20180530234432-1e491301e022"
	"golang.org/x/net v0.0.0-20180530234432-1e491301e022/go.mod"
	"golang.org/x/oauth2 v0.0.0-20180603041954-1e0a3fa8ba9a"
	"golang.org/x/oauth2 v0.0.0-20180603041954-1e0a3fa8ba9a/go.mod"
	"golang.org/x/sys v0.0.0-20180606202747-9527bec2660b"
	"golang.org/x/sys v0.0.0-20180606202747-9527bec2660b/go.mod"
	"google.golang.org/appengine v1.0.0"
	"google.golang.org/appengine v1.0.0/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/knqyf263/pet/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	go build || die
}

src_install() {
	dobin pet
	insinto /usr/share/zsh/site-functions
	doins misc/completions/zsh/_pet
}

pkg_postinst() {
	if ! has_version app-shells/peco ; then
		einfo "You should consider to install app-shells/peco"
		einfo "to be able to use selector command"
	fi
}
