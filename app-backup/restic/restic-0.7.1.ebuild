# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A backup program that is fast, efficient and secure"
HOMEPAGE="https://restic.github.io/"
SRC_URI="https://github.com/restic/restic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

DOCS=( README.rst CONTRIBUTING.md doc/design.rst doc/faq.rst doc/index.rst doc/manual.rst
	doc/rest_backend.rst doc/development.rst doc/talks.rst doc/tutorial_aws_s3.rst doc/installation.rst )

DEPEND="dev-lang/go
	test? ( sys-fs/fuse:0 )"

RDEPEND="sys-fs/fuse:0"

src_compile() {
	local mygoargs=(
		-v
		-work
		-x
		-tags release
		-ldflags "-w -X main.version=${PV}"
		-asmflags "-trimpath=${S}/vendor -trimpath=${S}"
		-gcflags "-trimpath=${S}/vendor -trimpath=${S}"
		-o "${S}"/restic cmds/restic
	)

	GOPATH="${S}:${S}/vendor" go build "${mygoargs[@]}" || die
}

src_test() {
	GOPATH="${S}:${S}/vendor" go test -v -work -x restic/... cmds/... || die
}

src_install() {
	dobin restic
	einstalldocs
}
