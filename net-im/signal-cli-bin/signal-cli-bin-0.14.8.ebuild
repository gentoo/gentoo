# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="signal-cli-${PV}"
DESCRIPTION="Send and receive messages of Signal Messenger over a command line interface"
HOMEPAGE="https://github.com/AsamK/signal-cli"
SRC_URI="
	https://github.com/AsamK/signal-cli/releases/download/v${PV}/${MY_P}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/AsamK/signal-cli/raw/v${PV}/README.md -> ${P}.README.md
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	virtual/jre:25
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.14.1-use-working-java-version.patch"
)

src_install() {
	dodir /opt/signal-cli/{lib,bin}
	insinto /opt/signal-cli
	doins -r lib
	into /opt/signal-cli
	dobin bin/signal-cli
	dosym -r /opt/signal-cli/bin/signal-cli /usr/bin/signal-cli
	newdoc "${DISTDIR}/${P}.README.md" README.md

	# "QA Notice: not portable"; recompress manpages
	gunzip man/man1/*.gz man/man5/*.gz || die
	doman man/man1/signal-cli.1 man/man5/signal-cli-dbus.5 man/man5/signal-cli-jsonrpc.5
}

pkg_postinst() {
	elog "Please read the README in /usr/share/doc/${PF}/"
	elog "re: how to register signal-cli with the signal service and"
	elog "how to send and receive messages"
}
