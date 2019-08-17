# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# go list -m all | magic
EGO_PN="git.sr.ht/~sircmpwn/aerc"
EGO_VENDOR=(
	"cloud.google.com/go v0.34.0 github.com/googleapis/google-cloud-go"
	"git.sr.ht/~sircmpwn/getopt 292febf82fd0"
	"git.sr.ht/~sircmpwn/pty 3a43678975a9"
	"github.com/DATA-DOG/go-sqlmock v1.3.3"
	"github.com/danwakefield/fnmatch cbb64ac3d964"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/ddevault/go-libvterm b7d861da3810"
	"github.com/emersion/go-imap v1.0.0"
	"github.com/emersion/go-imap-idle 2704abd7050e"
	"github.com/emersion/go-maildir 941194b0ac70"
	"github.com/emersion/go-message v0.10.5"
	"github.com/emersion/go-sasl 36b50694675c"
	"github.com/emersion/go-smtp v0.11.2"
	"github.com/emersion/go-textwrapper d0e65e56babe"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/gdamore/encoding v1.0.0"
	"github.com/gdamore/tcell 0abd73a30946 git.sr.ht/~sircmpwn/tcell" # fork
	"github.com/go-ini/ini v1.44.0"
	"github.com/golang/protobuf v1.3.2"
	"github.com/google/shlex c34317bd91bf"
	"github.com/gopherjs/gopherjs 3e4dfb77656c"
	"github.com/jtolds/gls v4.20.0"
	"github.com/kyoh86/xdg v1.0.0"
	"github.com/lucasb-eyer/go-colorful v1.0.2"
	"github.com/martinlindhe/base36 v1.0.0"
	"github.com/mattn/go-isatty v0.0.8"
	"github.com/mattn/go-pointer 49522c3f3791"
	"github.com/mattn/go-runewidth v0.0.4"
	"github.com/miolini/datacounter aa48df3a02c1"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/pkg/errors v0.8.1"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/riywo/loginshell 2ed199a032f6"
	"github.com/smartystreets/assertions v1.0.1"
	"github.com/smartystreets/goconvey 9d28bd7c0945"
	"github.com/stretchr/objx v0.1.0"
	"github.com/stretchr/testify v1.3.0"
	"golang.org/x/crypto f99c8df09eb5 github.com/golang/crypto"
	"golang.org/x/image f03afa92d3ff github.com/golang/image"
	"golang.org/x/net ca1201d0de80 github.com/golang/net"
	"golang.org/x/oauth2 0f29369cfe45 github.com/golang/oauth2"
	"golang.org/x/sync 112230192c58 github.com/golang/sync"
	"golang.org/x/sys fc99dfbffb4e github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"golang.org/x/tools d0a3d012864b github.com/golang/tools"
	"google.golang.org/appengine v1.6.1 github.com/golang/appengine"
	"gopkg.in/ini.v1 v1.44.0 github.com/go-ini/ini"
)

inherit golang-vcs-snapshot

DESCRIPTION="Email client for your terminal"
HOMEPAGE="https://aerc-mail.org"
SRC_URI="https://git.sr.ht/~sircmpwn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

RDEPEND="
	net-proxy/dante
	www-client/w3m
"

BDEPEND="
	app-text/scdoc
	>=dev-lang/go-1.12
"

src_prepare() {
	# needed to workaround go's assumptions about modules, GOPATH and dir sctructure
	mv -v "src/${EGO_PN}"/* ./ || die
	rm -rv src || die

	eapply_user
}

src_compile() {
	GOFLAGS="-mod=vendor -v -work -x" emake PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${ED}" install
	einstalldocs
}
