# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="signal-cli-${PV}"
DESCRIPTION="Send and receive messages of Signal Messenger over a command line interface"
HOMEPAGE="https://github.com/AsamK/signal-cli"
SRC_URI="
	https://github.com/AsamK/signal-cli/releases/download/v${PV}/${MY_P}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/AsamK/signal-cli/raw/v${PV}/README.md -> ${P}.README.md
	https://github.com/AsamK/signal-cli/raw/v${PV}/man/signal-cli.1.adoc -> ${P}.signal-cli.1.adoc
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	|| ( virtual/jdk:21 virtual/jre:21 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/asciidoc
"

PATCHES=(
	"${FILESDIR}/${PN}-0.13.1-use-working-java-version.patch"
)

src_unpack() {
	default
	cp "${DISTDIR}/${P}.signal-cli.1.adoc" signal-cli.1.adoc || die
}

src_compile() {
	default
	a2x --no-xmllint --doctype manpage --format manpage "${WORKDIR}/signal-cli.1.adoc" || die
}

src_install() {
	dodir /opt/signal-cli/{lib,bin}
	insinto /opt/signal-cli
	doins -r lib
	into /opt/signal-cli
	dobin bin/signal-cli
	dosym -r /opt/signal-cli/bin/signal-cli /usr/bin/signal-cli
	newdoc "${DISTDIR}/${P}.README.md" README.md
	doman "${WORKDIR}/signal-cli.1"
}

pkg_postinst() {
	elog "Please read /usr/share/doc/${PF}/README.md.bz2"
	elog "how to register signal-cli with the signal service and how to send"
	elog "and receive messages"
}
