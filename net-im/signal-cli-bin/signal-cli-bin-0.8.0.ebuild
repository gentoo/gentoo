# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="signal-cli-${PV}"
DESCRIPTION="Send and receive messages of Signal Messenger over a command line interface"
HOMEPAGE="https://github.com/AsamK/signal-cli/wiki"
SRC_URI="
	https://github.com/AsamK/signal-cli/releases/download/v${PV}/${MY_P}.tar.gz -> ${P}.tar.gz
	https://github.com/AsamK/signal-cli/raw/v${PV}/README.md -> ${P}.README.md
	https://github.com/AsamK/signal-cli/raw/v${PV}/man/signal-cli.1.adoc -> ${P}.signal-cli.1.adoc
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# signal-cli-bin depends on Java 11
#
# virtual/jre:11 exists but it's masked with this message:
#   Java 11 is not yet fully supported on Gentoo. Packages cannot depend
#   on it so these virtuals are not yet required. If you wish to use
#   Java 11 then install openjdk-(jdk|jre)-bin directly.

DEPEND="
	|| ( dev-java/openjdk-jre-bin:11 dev-java/openjdk:11 dev-java/openjdk-bin:11 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/asciidoc
"

PATCHES=(
	"${FILESDIR}/signal-cli-bin-${PV}-use-working-java-version.patch"
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
	insinto /usr
	doins -r lib
	dobin bin/signal-cli
	newdoc "${DISTDIR}/${P}.README.md" README.md
	doman "${WORKDIR}/signal-cli.1"
}

pkg_postinst() {
	elog "Please read /usr/share/doc/${PF}/README.md.bz2"
	elog "how to register signal-cli with the signal service and how to send"
	elog "and receive messages"
}
