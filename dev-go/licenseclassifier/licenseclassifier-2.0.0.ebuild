# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A set of tools that analyzes text to determine type of license"
HOMEPAGE="https://github.com/google/licenseclassifier"
SRC_URI="https://github.com/google/licenseclassifier/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~arthurzam/distfiles/dev-go/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # tests are currently failing

src_compile() {
	mkdir -p build-int build || die

	# Make a binary that will be used to generate licenses
	ego build -o build-int ./...

	# Make a binary that will use fixed path for the db
	cp -v file_system_resources.go{,.bak} || die
	local share="${EPREFIX}/usr/share/licenseclassifier"
	sed -i "s@= lcRoot()@= \"${share}\", error(nil)@" file_system_resources.go || die
	ego build -o build ./...

	# undo that change for tests
	mv -v file_system_resources.go{.bak,} || die

	build-int/license_serializer -output licenses || die
	build-int/license_serializer -forbidden -output licenses || die
}

src_test() {
	ego test ./...
}

src_install() {
	# Install package data (this isn't the package license)
	insinto usr/share/licenseclassifier
	doins licenses/*

	dobin build/*
	einstalldocs
}
