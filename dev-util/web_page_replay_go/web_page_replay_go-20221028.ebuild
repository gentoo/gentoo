# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A performance testing tool for recording and replaying web pages"
HOMEPAGE="https://chromium.googlesource.com/catapult/+/refs/heads/main/web_page_replay_go/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

SRC_URI="https://github.com/elkablo/web_page_replay_go/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/elkablo/web_page_replay_go/releases/download/v${PV}/web_page_replay_go-${PV}-deps.tar.xz"
S="${WORKDIR}/${P}/src"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/wpr-usage.patch"
	)

	default

	# default certificate, key and inject script in /usr/share/web_page_replay_go
	local f
	for f in wpr.go webpagereplay/legacyformatconvertor.go; do
		sed -i -e 's^"\(wpr_cert\.pem\|wpr_key\.pem\|deterministic\.js\)"^"/usr/share/web_page_replay_go/\1"^' "${f}" || die "sed-editing ${f} failed"
	done
}

src_compile() {
	local t

	for t in wpr.go httparchive.go; do
		go build ${GOFLAGS} -mod=mod "${t}" || die "compiling ${t} failed"
	done
}

src_install() {
	dobin wpr
	dobin httparchive

	insinto /usr/share/${PN}
	doins ../deterministic.js
	doins ../wpr_cert.pem
	doins ../wpr_key.pem
	doins ../wpr_public_hash.txt
}
