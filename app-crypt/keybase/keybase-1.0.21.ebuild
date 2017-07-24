# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils versionator

MY_PV=$(replace_version_separator 3 '-')

DESCRIPTION="Client for keybase.io"
HOMEPAGE="https://keybase.io/"
SRC_URI="https://github.com/keybase/client/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-lang/go-1.6:0"
RDEPEND="
	app-crypt/gnupg"

S="${WORKDIR}/src/github.com/keybase/client"

src_unpack() {
	unpack "${P}.tar.gz"
	mkdir -p "$(dirname "${S}")" || die
	mv "client-${MY_PV}" "${S}" || die
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
