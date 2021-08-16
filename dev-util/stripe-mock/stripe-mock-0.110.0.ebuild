# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_SRC="github.com/stripe/stripe-mock"
EGO_PN=${EGO_SRC}/...
inherit golang-build golang-vcs-snapshot

DESCRIPTION="Mock HTTP server that responds like the real Stripe API"
HOMEPAGE="https://github.com/stripe/stripe-mock"
SRC_URI="https://github.com/stripe/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 ~x86"

LICENSE="MIT ISC BSD-2"
SLOT="0"

src_install() {
	golang-build_src_install
	dobin bin/stripe-mock
	rm -rf "${D}$(get_golibdir_gopath)" || die
}
