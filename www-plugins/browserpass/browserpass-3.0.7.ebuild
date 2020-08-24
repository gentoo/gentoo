# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
MY_PN=browserpass-native

DESCRIPTION="WebExtension host binary for app-admin/pass, a UNIX password manager"
HOMEPAGE="https://github.com/browserpass/browserpass-native"

EGO_SUM=(
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.3"
	"github.com/konsorten/go-windows-terminal-sequences v1.0.3/go.mod"
	"github.com/mattn/go-zglob v0.0.2"
	"github.com/mattn/go-zglob v0.0.2/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rifflock/lfshook v0.0.0-20180920164130-b9218ef580f5"
	"github.com/rifflock/lfshook v0.0.0-20180920164130-b9218ef580f5/go.mod"
	"github.com/sirupsen/logrus v1.6.0"
	"github.com/sirupsen/logrus v1.6.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.2.2"
	"github.com/stretchr/testify v1.2.2/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"golang.org/x/sys v0.0.0-20190422165155-953cdadca894"
	"golang.org/x/sys v0.0.0-20190422165155-953cdadca894/go.mod"
	"golang.org/x/sys v0.0.0-20200625212154-ddb9806d33ae"
	"golang.org/x/sys v0.0.0-20200625212154-ddb9806d33ae/go.mod"
	)
go-module_set_globals
SRC_URI="https://github.com/browserpass/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="app-crypt/gnupg"

S="${WORKDIR}"/${MY_PN}-${PV}

src_compile() {
	go build || die

	sed -e 's|%%replace%%|'${EPREFIX}'/usr/libexec/browserpass-native|' \
		-i browser-files/firefox-host.json browser-files/chromium-host.json || die
}

src_install() {
	exeinto /usr/libexec
	doexe browserpass-native

	insinto /usr/lib/mozilla/native-messaging-hosts
	newins browser-files/firefox-host.json com.github.browserpass.native.json

	insinto /usr/lib64/mozilla/native-messaging-hosts
	newins browser-files/firefox-host.json com.github.browserpass.native.json

	insinto /etc/chromium/native-messaging-hosts
	newins browser-files/chromium-host.json com.github.browserpass.native.json

	insinto /etc/opt/chrome/native-messaging-hosts
	newins browser-files/chromium-host.json com.github.browserpass.native.json
}
