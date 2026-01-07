# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Let's Encrypt/ACME client (like certbot or acme.sh) and library written in Go"
HOMEPAGE="https://github.com/go-acme/lego/"

DOCUMENTATION_COMMIT=093311eaa03c9f9f4cfdd9ef6bbc24547abfea4f

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/go-acme/lego.git"
else
	SRC_URI="
	https://github.com/go-acme/lego/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/go-acme/lego/archive/${DOCUMENTATION_COMMIT}.tar.gz -> ${P}-docs.tar.gz
	https://github.com/rahilarious/gentoo-distfiles/releases/download/${P}/deps.tar.xz -> ${P}-deps.tar.xz
"
	KEYWORDS="~amd64 ~arm64"
fi

# main
LICENSE="MIT"
# deps
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MPL-2.0"
SLOT="0"

# some tests require network access otherwise get following error
# expected: "zoneee: unexpected status code: [status code: 401] body: Unauthorized"
# actual  : "zoneee: could not find zone for domain \"prefix.example.com\" (_acme-challenge.prefix.example.com.): could not find the start of authority for _acme-challenge.prefix.example.com.: read udp 10.0.0.1:54729->10.0.0.1:53: read: connection refused"
PROPERTIES="test_network"
RESTRICT="test"

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
		go-module_live_vendor
		EGIT_BRANCH="gh-pages"
		EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-${DOCUMENTATION_COMMIT}"
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	default
	find ../"${PN}"-"${DOCUMENTATION_COMMIT}"/ -type f -not -name '*.html' -delete || die
}

src_compile() {
	export CGO_ENABLED=0

	local VERSION
	if [[ ${PV} == 9999* ]]; then
		VERSION="$(git rev-parse HEAD)" || die
	else
		VERSION="${PV}"
	fi

	ego build -trimpath -ldflags "-X main.version=${VERSION}" -o dist/"${PN}" ./cmd/lego/
}

src_test() {
	ego test -v -cover ./...
}

src_install() {
	# primary program
	dobin dist/"${PN}"

	# docs
	einstalldocs
	dodoc -r ../"${PN}"-"${DOCUMENTATION_COMMIT}"/*
}
