# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.0"
	"github.com/BurntSushi/toml v0.3.0/go.mod"
	"github.com/alessio/shellescape v1.4.1"
	"github.com/alessio/shellescape v1.4.1/go.mod"
	"github.com/briandowns/spinner v0.0.0-20170614154858-48dbb65d7bd5"
	"github.com/briandowns/spinner v0.0.0-20170614154858-48dbb65d7bd5/go.mod"
	"github.com/chzyer/logex v1.1.10"
	"github.com/chzyer/logex v1.1.10/go.mod"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e"
	"github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e/go.mod"
	"github.com/chzyer/test v0.0.0-20210722231415-061457976a23"
	"github.com/chzyer/test v0.0.0-20210722231415-061457976a23/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/fatih/color v1.7.0"
	"github.com/fatih/color v1.7.0/go.mod"
	"github.com/golang/protobuf v1.2.0"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/google/go-github v15.0.0+incompatible"
	"github.com/google/go-github v15.0.0+incompatible/go.mod"
	"github.com/google/go-querystring v1.0.0"
	"github.com/google/go-querystring v1.0.0/go.mod"
	"github.com/hashicorp/go-cleanhttp v0.5.1"
	"github.com/hashicorp/go-cleanhttp v0.5.1/go.mod"
	"github.com/hashicorp/go-hclog v0.9.2"
	"github.com/hashicorp/go-hclog v0.9.2/go.mod"
	"github.com/hashicorp/go-retryablehttp v0.6.8"
	"github.com/hashicorp/go-retryablehttp v0.6.8/go.mod"
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
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/cobra v0.0.3/go.mod"
	"github.com/spf13/pflag v1.0.1"
	"github.com/spf13/pflag v1.0.1/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.4.0"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/xanzy/go-gitlab v0.50.3"
	"github.com/xanzy/go-gitlab v0.50.3/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20201021035429-f5854403a974"
	"golang.org/x/net v0.0.0-20201021035429-f5854403a974/go.mod"
	"golang.org/x/oauth2 v0.0.0-20181106182150-f42d05182288"
	"golang.org/x/oauth2 v0.0.0-20181106182150-f42d05182288/go.mod"
	"golang.org/x/sync v0.0.0-20201020160332-67f06af15bc9/go.mod"
	"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c"
	"golang.org/x/sync v0.0.0-20210220032951-036812b2e83c/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20200930185726-fdedc70b468f/go.mod"
	"golang.org/x/sys v0.0.0-20211116061358-0a5406a5449c"
	"golang.org/x/sys v0.0.0-20211116061358-0a5406a5449c/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/time v0.0.0-20191024005414-555d28b269f0"
	"golang.org/x/time v0.0.0-20191024005414-555d28b269f0/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"google.golang.org/appengine v1.3.0"
	"google.golang.org/appengine v1.3.0/go.mod"
	"gopkg.in/alessio/shellescape.v1 v1.0.0-20170105083845-52074bc9df61"
	"gopkg.in/alessio/shellescape.v1 v1.0.0-20170105083845-52074bc9df61/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.2"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	)
go-module_set_globals

DESCRIPTION="Simple command-line snippet manager"
HOMEPAGE="https://github.com/knqyf263/pet"
SRC_URI="https://github.com/knqyf263/pet/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	emake build
}

src_install() {
	dobin pet
	insinto /usr/share/zsh/site-functions
	doins misc/completions/zsh/_pet
}

pkg_postinst() {
	if ! has_version app-shells/peco && ! has_version app-shells/fzf ; then
		einfo "You should consider to install app-shells/peco or"
		einfo "app-shells/fzf to be able to use selector command"
	fi
}
