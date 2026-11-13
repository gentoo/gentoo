# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Syslog message parser"
HOMEPAGE="https://github.com/verbosemode/syslog-message"
SRC_URI="https://github.com/verbosemode/${PN}/releases/download/${PV}/${P}.tbz"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="dev-ml/ptime:=[ocamlopt?]"
DEPEND="${RDEPEND}"
