# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils versionator git-r3

MY_PV=$(replace_version_separator 3 '-')

DESCRIPTION="Client for keybase.io"
HOMEPAGE="https://keybase.io/"
EGIT_REPO_URI="https://github.com/keybase/client.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-lang/go-1.6:0"
RDEPEND="
	app-crypt/gnupg"

S="${WORKDIR}/src/github.com/keybase/client"

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
}

src_install() {
	dobin "${T}/keybase"
}

pkg_postinst() {
	elog "Run the service: keybase service"
	elog "Run the client:  keybase login"
}
