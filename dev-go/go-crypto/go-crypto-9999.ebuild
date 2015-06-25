# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-go/go-crypto/go-crypto-9999.ebuild,v 1.6 2015/06/25 17:21:45 williamh Exp $

EAPI=5
inherit golang-build golang-vcs
EGO_PN=golang.org/x/crypto/...
EGO_SRC=golang.org/x/crypto

DESCRIPTION="Go supplementary cryptography libraries"
HOMEPAGE="https://godoc.org/${GO_PN}"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=""

src_prepare() {
	# disable broken tests
	sed -e 's:TestAgentForward(:_\0:' \
		-i src/${EGO_SRC}/ssh/test/agent_unix_test.go || die
	sed -e 's:TestRunCommandSuccess(:_\0:' \
		-e 's:TestRunCommandStdin(:_\0:' \
		-e 's:TestRunCommandStdinError(:_\0:' \
		-e 's:TestRunCommandWeClosed(:_\0:' \
		-e 's:TestFuncLargeRead(:_\0:' \
		-e 's:TestKeyChange(:_\0:' \
		-e 's:TestValidTerminalMode(:_\0:' \
		-i src/${EGO_SRC}/ssh/test/session_test.go || die
}
