# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GIT_COMMIT=4203e559f331009df04a3ca47820989c6c43e138
inherit go-module

DESCRIPTION="Docker registry v2 command line client"
HOMEPAGE="https://github.com/genuinetools/reg"
SRC_URI="https://github.com/genuinetools/reg/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="MIT Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="acct-group/reg
	acct-user/reg
"
RDEPEND="${DEPEND}"

RESTRICT+=" test "
S="${WORKDIR}/${PN}-${GIT_COMMIT}"

PATCHES=(
	"${FILESDIR}"/${P}-config.patch
)

src_compile() {
	export -n XDG_CACHE_HOME
	ego build -ldflags "
		-X ${EGO_PN}/version.GITCOMMIT=${GIT_COMMIT}
		-X ${EGO_PN}/version.VERSION=${PV}" \
			-o reg .
}

src_install() {
	dobin reg
	dodoc README.md
	insinto /var/lib/${PN}
	doins -r server/*
	newinitd "${FILESDIR}"/reg.initd reg
	newconfd "${FILESDIR}"/reg.confd reg
	keepdir /var/log/reg
	fowners -R reg:reg /var/log/reg /var/lib/reg/static
}
