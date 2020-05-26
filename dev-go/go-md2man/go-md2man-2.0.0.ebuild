# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="A utility to convert markdown to man pages"
	SRC_URI="https://github.com/cpuguy83/go-md2man/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/cpuguy83/go-md2man"

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64"

# restrict tests because they need network-sandbox disabled
# bug https://bugs.gentoo.org/715028
RESTRICT+=" test"

src_compile() {
	emake BUILD_FLAGS="-mod=vendor" build
}

src_install() {
	"${S}"/bin/go-md2man -in go-md2man.1.md -out go-md2man.1 ||
		die "Unable to create man page"
	dobin bin/go-md2man
	doman go-md2man.1
}

src_test() {
	emake test
}
