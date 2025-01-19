# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Automatically gets credentials for Amazon ECR on docker push/docker pull"
HOMEPAGE="https://github.com/awslabs/amazon-ecr-credential-helper"
SRC_URI="https://github.com/awslabs/amazon-ecr-credential-helper/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/app-containers/${PN}/${P}-deps.tar.xz"
S=${WORKDIR}/${P}/ecr-login

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build ./cli/docker-credential-ecr-login
}

src_test() {
	ego test ./...
}

src_install() {
	dobin docker-credential-ecr-login
	doman ../docs/docker-credential-ecr-login.1
	dodoc ../README.md
}
