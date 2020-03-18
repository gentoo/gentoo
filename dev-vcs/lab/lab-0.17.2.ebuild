# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

DESCRIPTION="Lab wraps Git or Hub, making it simple to interact with repositories on GitLab"
HOMEPAGE="https://zaquestion.github.io/lab"

EGO_VENDOR=(
"github.com/avast/retry-go 5469272a8171"
"github.com/cpuguy83/go-md2man v1.0.8"
"github.com/davecgh/go-spew v1.1.1"
"github.com/fsnotify/fsnotify v1.4.7"
"github.com/gdamore/encoding v1.0.0"
"github.com/gdamore/tcell v1.3.0"
"github.com/golang/protobuf v1.2.0"
"github.com/google/go-querystring v1.0.0"
"github.com/hashicorp/hcl ef8a98b0bbce"
"github.com/inconshreveable/mousetrap v1.0.0"
"github.com/lucasb-eyer/go-colorful v1.0.3"
"github.com/lunixbochs/vtclean 2d01aacdc34a"
"github.com/magiconair/properties v1.7.6"
"github.com/mattn/go-runewidth v0.0.7"
"github.com/mitchellh/mapstructure 00c29f56e238"
"github.com/pelletier/go-toml v1.1.0"
"github.com/pkg/errors v0.8.0"
"github.com/pmezard/go-difflib v1.0.0"
"github.com/rivo/tview 82b05c9fb329"
"github.com/rivo/uniseg v0.1.0"
"github.com/russross/blackfriday v1.5.1"
"github.com/spf13/afero v1.1.0"
"github.com/spf13/cast v1.2.0"
"github.com/spf13/cobra v0.0.1-zsh-completion-custom github.com/rsteube/cobra" #fork
"github.com/spf13/jwalterweatherman 7c0cea34c8ec"
"github.com/spf13/pflag v1.0.1"
"github.com/spf13/viper 15738813a09d"
"github.com/stretchr/testify v1.2.2"
"github.com/tcnksm/go-gitconfig v0.1.2"
"github.com/xanzy/go-gitlab 7bc4155e8bf8"
"golang.org/x/crypto c2843e01d9a2 github.com/golang/crypto"
"golang.org/x/net 3b0461eec859 github.com/golang/net"
"golang.org/x/oauth2 f42d05182288 github.com/golang/oauth2"
"golang.org/x/sys ac6580df4449 github.com/golang/sys"
"golang.org/x/text v0.3.2 github.com/golang/text"
"google.golang.org/appengine v1.3.0 github.com/golang/appengine"
"gopkg.in/yaml.v2 v2.2.1 github.com/go-yaml/yaml"
)

SRC_URI="https://github.com/zaquestion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

RDEPEND="dev-vcs/git"

RESTRICT="test" #tries to write to /src and fetch from gitlab

src_compile() {
	emake VERSION="${PV}"
	mkdir -v "${T}/comp" || die
	./lab completion bash > "${T}/comp/lab" || die
	./lab completion zsh > "${T}/comp/_lab" || die
}

src_install() {
	dobin lab
	einstalldocs
	dobashcomp "${T}/comp/lab"
	insinto /usr/share/zsh/site-functions
	doins "${T}/comp/_lab"
}
