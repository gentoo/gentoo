# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Email client for your terminal"
HOMEPAGE="https://aerc-mail.org"

# go list -m all | magic
EGO_VENDOR=(
	"git.sr.ht/~sircmpwn/getopt 292febf82fd0 git.sr.ht/~sircmpwn/getopt"
	"git.sr.ht/~sircmpwn/pty 3a43678975a9 git.sr.ht/~sircmpwn/pty"
	"github.com/danwakefield/fnmatch cbb64ac3d964"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/ddevault/go-libvterm b7d861da3810"
	"github.com/emersion/go-imap v1.0.0"
	"github.com/emersion/go-imap-idle 2704abd7050e"
	"github.com/emersion/go-maildir 941194b0ac70"
	"github.com/emersion/go-message v0.10.7"
	"github.com/emersion/go-sasl 240c8404624e"
	"github.com/emersion/go-smtp v0.11.2"
	"github.com/emersion/go-textwrapper d0e65e56babe"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/gdamore/encoding v1.0.0"
	"github.com/gdamore/tcell 3fdb6bc01a50 git.sr.ht/~sircmpwn/tcell" # fork
	"github.com/go-ini/ini v1.44.0"
	"github.com/golang/protobuf v1.3.2"
	"github.com/google/shlex c34317bd91bf"
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
	"github.com/stretchr/testify v1.3.0"
	"github.com/zenhack/go.notmuch 5a1961965cfb"
	"golang.org/x/net 74dc4d7220e7 github.com/golang/net"
	"golang.org/x/oauth2 0f29369cfe45 github.com/golang/oauth2"
	"golang.org/x/sys fde4db37ae7a github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
	"google.golang.org/appengine v1.6.1 github.com/golang/appengine"
)

SRC_URI="https://git.sr.ht/~sircmpwn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

BDEPEND=">=app-text/scdoc-1.9.7"

src_compile() {
	emake PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${ED}" install
	einstalldocs
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "If you want to allow your users to activate html email"
		elog "processing via w3m as shown in the tutorial, make sure you"
		elog "emerge net-proxy/dante and www-client/w3m"
	fi

	local v
	for v in ${REPLACING_VERSIONS}; do
		if ver_test $v -lt 0.3.0-r1; then
			elog "The dependencies on net-proxy/dante and www-client/w3m"
			elog "have been removed since they are optional."
			elog "Please emerge them before the next --depclean if you"
			elog "need to use them."
		fi
	done
}
