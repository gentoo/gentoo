# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Mock HTTP server that responds like the real Stripe API"
HOMEPAGE="https://github.com/stripe/stripe-mock/"
SRC_URI="https://github.com/stripe/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT ISC BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

src_compile() {
	emake build
}

src_test() {
	emake test
}

src_install() {
	dobin stripe-mock
	einstalldocs
}
