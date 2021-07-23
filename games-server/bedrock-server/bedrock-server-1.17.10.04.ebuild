# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	dev-libs/openssl:0/1.1
	net-misc/curl[ssl]
	sys-libs/zlib
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
	doins {permissions,whitelist}.json server.properties
	doins -r {behavior,resource}_packs definitions structures

	dodir /opt/bin
	dosym ../bedrock-server/bedrock_server /opt/bin/bedrock-server

	newinitd "${FILESDIR}"/bedrock-server.initd-r2 bedrock-server
	newconfd "${FILESDIR}"/bedrock-server.confd bedrock-server

	einstalldocs
}
