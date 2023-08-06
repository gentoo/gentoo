# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="The official bedrock (non-java) based server for the sandbox video game"
HOMEPAGE="https://www.minecraft.net/"
SRC_URI="https://minecraft.azureedge.net/bin-linux/${P}.zip"
S="${WORKDIR}"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	acct-group/bedrock
	acct-user/bedrock
	app-misc/dtach
	net-misc/curl
"

BDEPEND="app-arch/unzip"

RESTRICT="bindist mirror"

DOCS=(
	"bedrock_server_how_to.html"
	"release-notes.txt"
)

QA_PREBUILT="opt/bedrock-server/bedrock_server"

src_compile() {
	:;
}

src_install() {
	exeinto /opt/bedrock-server
	doexe bedrock_server

	insinto /opt/bedrock-server
	doins {allowlist,permissions}.json server.properties
	doins -r {behavior,resource}_packs definitions

	dodir /opt/bin
	dosym ../bedrock-server/bedrock_server /opt/bin/bedrock-server

	newinitd "${FILESDIR}"/bedrock-server.initd-r4 bedrock-server
	newconfd "${FILESDIR}"/bedrock-server.confd bedrock-server
	systemd_newunit "${FILESDIR}"/bedrock-server.service bedrock-server@.service

	einstalldocs
}
