# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune

DESCRIPTION="Logs reporter to syslog (UDP/TCP/TLS)"
HOMEPAGE="https://github.com/hannesm/logs-syslog"
SRC_URI="https://github.com/hannesm/${PN}/releases/download/v${PV}/${P}.tbz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ocamlopt"

RDEPEND="
	dev-ml/logs:=[ocamlopt?]
	dev-ml/ptime:=[ocamlopt?]
	dev-ml/syslog-message:=[ocamlopt?]
"
DEPEND="${RDEPEND}"
