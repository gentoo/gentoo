# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Email client for your terminal"
HOMEPAGE="https://aerc-mail.org"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/aerc"
else
	EGO_SUM=(
		"cloud.google.com/go v0.34.0/go.mod"
		"git.sr.ht/~sircmpwn/getopt v0.0.0-20190808004552-daaf1274538b"
		"git.sr.ht/~sircmpwn/getopt v0.0.0-20190808004552-daaf1274538b/go.mod"
		"git.sr.ht/~sircmpwn/tcell v0.0.0-20190807054800-3fdb6bc01a50"
		"git.sr.ht/~sircmpwn/tcell v0.0.0-20190807054800-3fdb6bc01a50/go.mod"
		"github.com/DATA-DOG/go-sqlmock v1.3.3/go.mod"
		"github.com/ProtonMail/crypto v0.0.0-20200420072808-71bec3603bf3"
		"github.com/ProtonMail/crypto v0.0.0-20200420072808-71bec3603bf3/go.mod"
		"github.com/creack/pty v1.1.10"
		"github.com/creack/pty v1.1.10/go.mod"
		"github.com/danwakefield/fnmatch v0.0.0-20160403171240-cbb64ac3d964"
		"github.com/danwakefield/fnmatch v0.0.0-20160403171240-cbb64ac3d964/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/ddevault/go-libvterm v0.0.0-20190526194226-b7d861da3810"
		"github.com/ddevault/go-libvterm v0.0.0-20190526194226-b7d861da3810/go.mod"
		"github.com/emersion/go-imap v1.0.4"
		"github.com/emersion/go-imap v1.0.4/go.mod"
		"github.com/emersion/go-imap-idle v0.0.0-20190519112320-2704abd7050e"
		"github.com/emersion/go-imap-idle v0.0.0-20190519112320-2704abd7050e/go.mod"
		"github.com/emersion/go-maildir v0.2.0"
		"github.com/emersion/go-maildir v0.2.0/go.mod"
		"github.com/emersion/go-message v0.11.1"
		"github.com/emersion/go-message v0.11.1/go.mod"
		"github.com/emersion/go-pgpmail v0.0.0-20200303213726-db035a3a4139"
		"github.com/emersion/go-pgpmail v0.0.0-20200303213726-db035a3a4139/go.mod"
		"github.com/emersion/go-sasl v0.0.0-20190817083125-240c8404624e/go.mod"
		"github.com/emersion/go-sasl v0.0.0-20191210011802-430746ea8b9b"
		"github.com/emersion/go-sasl v0.0.0-20191210011802-430746ea8b9b/go.mod"
		"github.com/emersion/go-smtp v0.12.1"
		"github.com/emersion/go-smtp v0.12.1/go.mod"
		"github.com/emersion/go-textwrapper v0.0.0-20160606182133-d0e65e56babe"
		"github.com/emersion/go-textwrapper v0.0.0-20160606182133-d0e65e56babe/go.mod"
		"github.com/fsnotify/fsnotify v1.4.7"
		"github.com/fsnotify/fsnotify v1.4.7/go.mod"
		"github.com/gdamore/encoding v1.0.0"
		"github.com/gdamore/encoding v1.0.0/go.mod"
		"github.com/go-ini/ini v1.52.0"
		"github.com/go-ini/ini v1.52.0/go.mod"
		"github.com/golang/protobuf v1.2.0/go.mod"
		"github.com/golang/protobuf v1.3.1/go.mod"
		"github.com/golang/protobuf v1.3.4"
		"github.com/golang/protobuf v1.3.4/go.mod"
		"github.com/google/shlex v0.0.0-20191202100458-e7afc7fbc510"
		"github.com/google/shlex v0.0.0-20191202100458-e7afc7fbc510/go.mod"
		"github.com/gopherjs/gopherjs v0.0.0-20181017120253-0766667cb4d1/go.mod"
		"github.com/gopherjs/gopherjs v0.0.0-20190430165422-3e4dfb77656c"
		"github.com/gopherjs/gopherjs v0.0.0-20190430165422-3e4dfb77656c/go.mod"
		"github.com/imdario/mergo v0.3.8"
		"github.com/imdario/mergo v0.3.8/go.mod"
		"github.com/jtolds/gls v4.20.0+incompatible"
		"github.com/jtolds/gls v4.20.0+incompatible/go.mod"
		"github.com/kyoh86/xdg v1.2.0"
		"github.com/kyoh86/xdg v1.2.0/go.mod"
		"github.com/lucasb-eyer/go-colorful v1.0.2/go.mod"
		"github.com/lucasb-eyer/go-colorful v1.0.3"
		"github.com/lucasb-eyer/go-colorful v1.0.3/go.mod"
		"github.com/martinlindhe/base36 v1.0.0"
		"github.com/martinlindhe/base36 v1.0.0/go.mod"
		"github.com/mattn/go-isatty v0.0.12"
		"github.com/mattn/go-isatty v0.0.12/go.mod"
		"github.com/mattn/go-pointer v0.0.0-20180825124634-49522c3f3791/go.mod"
		"github.com/mattn/go-pointer v0.0.0-20190911064623-a0a44394634f"
		"github.com/mattn/go-pointer v0.0.0-20190911064623-a0a44394634f/go.mod"
		"github.com/mattn/go-runewidth v0.0.4/go.mod"
		"github.com/mattn/go-runewidth v0.0.8"
		"github.com/mattn/go-runewidth v0.0.8/go.mod"
		"github.com/miolini/datacounter v1.0.2"
		"github.com/miolini/datacounter v1.0.2/go.mod"
		"github.com/mitchellh/go-homedir v1.1.0"
		"github.com/mitchellh/go-homedir v1.1.0/go.mod"
		"github.com/pkg/errors v0.9.1"
		"github.com/pkg/errors v0.9.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/riywo/loginshell v0.0.0-20190610082906-2ed199a032f6"
		"github.com/riywo/loginshell v0.0.0-20190610082906-2ed199a032f6/go.mod"
		"github.com/smartystreets/assertions v0.0.0-20180927180507-b2de0cb4f26d/go.mod"
		"github.com/smartystreets/assertions v1.0.1"
		"github.com/smartystreets/assertions v1.0.1/go.mod"
		"github.com/smartystreets/goconvey v0.0.0-20190710185942-9d28bd7c0945"
		"github.com/smartystreets/goconvey v0.0.0-20190710185942-9d28bd7c0945/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/testify v1.3.0"
		"github.com/stretchr/testify v1.3.0/go.mod"
		"github.com/zenhack/go.notmuch v0.0.0-20190821052706-5a1961965cfb"
		"github.com/zenhack/go.notmuch v0.0.0-20190821052706-5a1961965cfb/go.mod"
		"golang.org/x/image v0.0.0-20190523035834-f03afa92d3ff/go.mod"
		"golang.org/x/net v0.0.0-20180724234803-3673e40ba225/go.mod"
		"golang.org/x/net v0.0.0-20190108225652-1e06a53dbb7e/go.mod"
		"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
		"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
		"golang.org/x/net v0.0.0-20190603091049-60506f45cf65/go.mod"
		"golang.org/x/net v0.0.0-20200301022130-244492dfa37a"
		"golang.org/x/net v0.0.0-20200301022130-244492dfa37a/go.mod"
		"golang.org/x/oauth2 v0.0.0-20200107190931-bf48bf16ab8d"
		"golang.org/x/oauth2 v0.0.0-20200107190931-bf48bf16ab8d/go.mod"
		"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
		"golang.org/x/sys v0.0.0-20190626150813-e07cf5db2756/go.mod"
		"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
		"golang.org/x/sys v0.0.0-20200302150141-5c8b2ff67527"
		"golang.org/x/sys v0.0.0-20200302150141-5c8b2ff67527/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.2"
		"golang.org/x/text v0.3.2/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20190328211700-ab21143f2384/go.mod"
		"google.golang.org/appengine v1.4.0/go.mod"
		"google.golang.org/appengine v1.6.5"
		"google.golang.org/appengine v1.6.5/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/ini.v1 v1.44.0"
		"gopkg.in/ini.v1 v1.44.0/go.mod"
		"gopkg.in/yaml.v2 v2.2.8"
		"gopkg.in/yaml.v2 v2.2.8/go.mod"
	)
	go-module_set_globals
	SRC_URI="https://git.sr.ht/~sircmpwn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE="notmuch"

BDEPEND="
	>=app-text/scdoc-1.9.7
	>=dev-lang/go-1.13
"

DEPEND="notmuch? ( net-mail/notmuch:= )"
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	use notmuch && export GOFLAGS="-tags=notmuch"
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
