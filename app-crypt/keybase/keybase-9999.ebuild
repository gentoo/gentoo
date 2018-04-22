# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd user versionator git-r3

MY_PV=$(replace_version_separator 3 '-')

DESCRIPTION="Client for keybase.io"
HOMEPAGE="https://keybase.io/"
EGIT_REPO_URI="https://github.com/keybase/client.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+suid"

DEPEND="
	>=dev-lang/go-1.6:0
	app-crypt/kbfs"
RDEPEND="
	app-crypt/gnupg"

S="${WORKDIR}/src/github.com/keybase/client"

pkg_setup() {
	enewuser keybasehelper
}

src_unpack() {
	git-r3_src_unpack
	mkdir -p "$(dirname "${S}")" || die
	ln -s "${WORKDIR}/${PN}-${MY_PV}" "${S}" || die
}

src_compile() {
	GOPATH="${WORKDIR}:${S}/go/vendor" \
		go build -v -x \
		-tags production \
		-o "${T}/keybase" \
		github.com/keybase/client/go/keybase || die
	GOPATH="${WORKDIR}" \
		go build -v -x \
		-tags production \
		-o "${T}/keybase-mount-helper" \
		github.com/keybase/client/go/mounter/keybase-mount-helper || die
}

src_install() {
	dobin "${T}/keybase"
	dodir "/var/lib/keybase"
	fowners keybasehelper:keybasehelper "/var/lib/keybase"
	dosym "/tmp/keybase" "/var/lib/keybase/mount1"
	dobin "${T}/keybase-mount-helper"
	fowners keybasehelper:keybasehelper "/usr/bin/keybase-mount-helper"
	use suid && fperms 4755 "/usr/bin/keybase-mount-helper"
	dobin "${S}/packaging/linux/run_keybase"
	systemd_douserunit "${S}/packaging/linux/systemd/keybase.service"
}

pkg_postinst() {
	elog "Run the service: keybase service"
	elog "Run the client:  keybase login"
	elog "Restart keybase: run_keybase"
}
