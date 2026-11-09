# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="A simple library for bigstrings"
HOMEPAGE="https://git.robur.coop/robur/bstr"
SRC_URI="https://github.com/robur-coop/bstr/releases/download/v${PV}/${P}.tbz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

src_prepare() {
	default
	# depends on unpackaged crowbar
	rm -rf fuzz || die
}
