# Copyright 2025 Gentoo Authors
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
	sed -e '/^build-linux/s/ checkstyle//' -i makefile || die
}

src_compile() {
	emake GO_BUILD="go build" build-linux-${GOARCH}
}

src_install() {
	dobin bin/linux_${GOARCH}/ssmcli bin/linux_${GOARCH}_plugin/session-manager-plugin
	local DOCS=( README.md RELEASENOTES.md )
	einstalldocs

	systemd_dounit packaging/linux/ssmcli.service
}
