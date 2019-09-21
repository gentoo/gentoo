# Copyright 2001-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A suite of programs to use native stores to keep Docker credentials safe"
HOMEPAGE="https://github.com/docker/docker-credential-helpers"
EGO_PN=github.com/docker/docker-credential-helpers

LICENSE="MIT"
SLOT="0"

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="v${PV}"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	inherit golang-vcs-snapshot
fi
inherit golang-build

IUSE="gnome-keyring pass"
REQUIRED_USE="|| ( gnome-keyring pass )"
RESTRICT="test"

DEPEND="gnome-keyring? ( app-crypt/libsecret )"

RDEPEND="(
	${DEPEND}
	pass? ( app-admin/pass )
)
"

S=${WORKDIR}/${P}/src/${EGO_PN}

src_compile() {
	local -x GOPATH="${WORKDIR}/${P}"
	use gnome-keyring && emake secretservice
	use pass && emake pass
}

src_install() {
	dobin bin/*
	dodoc CHANGELOG.md MAINTAINERS README.md
}

pkg_postinst() {
	if use gnome-keyring; then
		elog "For gnome-keyring/kwallet add:\n"
		elog '		"credStore": "secretservice"'"\n"
	fi
	if use pass; then
		elog "For 'pass' add:\n"
		elog '		"credStore": "pass"'"\n"
	fi
	elog "to your ~/.docker/config.json"
}
