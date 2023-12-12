# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker

DESCRIPTION="A privacy-first, open-source platform for knowledge sharing and management."
HOMEPAGE="https://github.com/logseq/logseq"
SRC_URI="https://github.com/logseq/logseq/releases/download/${PV}/logseq-linux-x64-${PV}.zip -> ${P}.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror splitdebug"

DEPEND=""
RDEPEND=">=dev-libs/openssl-3"
BDEPEND="app-arch/unzip"

QA_PREBUILT="*"
S="${WORKDIR}/Logseq-linux-x64"

src_install() {
	domenu "${FILESDIR}/logseq-desktop.desktop"
	doicon "${S}/resources/app/icons/logseq.png"
	mkdir -p "${D}/opt/logseq-desktop" || die
	cp -r "${S}"/* "${D}/opt/logseq-desktop/" || die
	dosym ../logseq-desktop/Logseq /opt/bin/logseq
}

pkg_postinst() {
	update-desktop-database
}
