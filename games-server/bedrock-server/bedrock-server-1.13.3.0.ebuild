# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The official bedrock based server for the sandbox video game"
HOMEPAGE="https://www.minecraft.net/"
SRC_URI="https://minecraft.azureedge.net/bin-linux/${P}.zip"

LICENSE="Mojang"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"

RDEPEND="
	acct-group/bedrock
	acct-user/bedrock
	dev-libs/openssl:0/1.1
	net-misc/curl
"

RESTRICT="bindist mirror strip"

S="${WORKDIR}"

DOCS=(
	"bedrock_server_how_to.html"
	"release-notes.txt"
)

QA_PREBUILT="
	opt/bedrock-server/bedrock_server
	opt/bedrock-server/libCrypto.so
"

src_compile() {
	:;
}

src_install() {
	diropts -o bedrock -g bedrock
	dodir /opt/bedrock-server

	diropts
	exeinto /opt/bedrock-server
	doexe bedrock_server *.so "${FILESDIR}"/bedrock_server-bin

	insinto /opt/bedrock-server
	doins *.json *.properties
	doins -r behavior_packs definitions resource_packs structures

	dodir /opt/bin
	dosym ../bedrock-server/bedrock_server-bin /opt/bin/bedrock_server

	newinitd "${FILESDIR}"/bedrock-server.initd bedrock-server

	einstalldocs
}
