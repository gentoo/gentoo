# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit vcs-snapshot

DESCRIPTION="command line client for the opsgenie service"
HOMEPAGE="https://docs.opsgenie.com/docs/lamp-command-line-interface-for-opsgenie"
HASH=062016b
SRC_URI="https://github.com/opsgenie/${PN}/archive/${HASH}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-vendor.tar.gz"

# I followed the following steps to create the vendor tarball:
#
# git clone https://github.com/opsgenie/opsgenie-lamp
# cd opsgenie-lamp
# go mod init # creates go.mod and go.sum
# go mod vendor # updates go.mod/sum and adds vendor directory
# mv -i go.mod go.sum vendor
# tar cf ${P}.tar vendor
# gzip ${P}.tar
#
# Upstream doesn't tag releases, but the most recent version number is
# in the  sources, see the lampVersion variable.

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/go:="

RESTRICT="strip"

src_prepare() {
		mv ../${P}-vendor vendor || die "mv failed"
		mv vendor/go.mod vendor/go.sum . || die "mv failed"
	default
}

src_compile() {
	GOCACHE="${T}"/go-cache go build -mod vendor || die "build failed"
}

src_install() {
	newbin ${PN} lamp
dodoc conf/lamp.conf
	einstalldocs
}
