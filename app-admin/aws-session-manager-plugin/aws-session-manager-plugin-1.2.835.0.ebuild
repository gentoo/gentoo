# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="AWS Session Manager Plugin for aws-cli"
HOMEPAGE="https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html
	https://github.com/aws/session-manager-plugin"
SRC_URI="https://github.com/aws/session-manager-plugin/archive/${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${P#aws-}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default
	sed -e '/^build-linux/s/ checkstyle//' \
		-e 's/-s //g' -i makefile || die
}

src_compile() {
	local TARGET
	if use amd64; then
		TARGET=build-linux-amd64
	elif use arm64; then
		TARGET=build-arm64
	else
		die "Unsupported architecture: ${GOARCH}"
	fi
	emake GO_BUILD="go build" ${TARGET}
}

src_install() {
	dobin bin/linux_${GOARCH}_plugin/session-manager-plugin
	use amd64 && dobin bin/linux_amd64/ssmcli

	local DOCS=( README.md RELEASENOTES.md )
	einstalldocs

	systemd_dounit packaging/linux/ssmcli.service
}
