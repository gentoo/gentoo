# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="lightweight incoming webhook server to run shell commands"
HOMEPAGE="https://github.com/adnanh/webhook/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adnanh/webhook/"
else
	SRC_URI="https://github.com/adnanh/webhook/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/webhook-${PV}"
fi

# SPDX:BSD-3-Clause is 'BSD' in Gentoo
# SPDX:BSD-2-Clause is 'BSD-2' in Gentoo
LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"

BDEPEND=">=dev-lang/go-1.13"
RESTRICT="test" # hardcoded paths, plus go extra dependencies not included in tarball

DOCS=(
	README.md
	hooks.json.example
	hooks.json.tmpl.example
	hooks.yaml.example
	hooks.yaml.tmpl.example
	docs/Hook-Definition.md
	docs/Hook-Examples.md
	docs/Hook-Rules.md
	docs/Referencing-Request-Values.md
	docs/Templates.md
	docs/Webhook-Parameters.md
)

# Do not let these leak from outside into the package
unset GOBIN GOPATH GOCODE

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	# Golang LDFLAGS are not the same as GCC/Binutils LDFLAGS
	unset LDFLAGS
	# -mod=vendor is needed because the go version specified in go.mod
	# is too low.
	ego build -mod=vendor
}

src_install() {
	dobin webhook

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}

	insinto /etc
	newins "${FILESDIR}/${PN}.json.example" ${PN}.json

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" ${PN}

	einstalldocs
}

pkg_postinst() {
	elog
	elog "Note that due to technical restrictions the webhook server runs as root,"
	elog "which has obvious security implications."
	elog "Please see the project home page for information about Hook rules and"
	elog "restrict access to the server, for example by limiting the listening IP/port."
	elog
}
