# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A set of tools that analyzes text to determine type of license"
HOMEPAGE="https://github.com/google/licenseclassifier"
LICENSE="Apache-2.0 MIT"
SLOT="0"

EGO_PN=github.com/google/${PN}
EGIT_REPO_URI="https://${EGO_PN}.git"

inherit go-module

if [[ ${PV} == *9999* ]]; then
	inherit git-r3

	src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
	}
else
	KEYWORDS="~amd64"
	EGIT_COMMIT="879cb1424de0ab6dbb3d7a0788a0e40c2515a1b7"
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

	EGO_SUM=(
		"github.com/davecgh/go-spew v1.1.0"
		"github.com/google/go-cmp v0.2.0"
		"github.com/pmezard/go-difflib v1.0.0"
		"github.com/sergi/go-diff v1.0.0"
		"github.com/stretchr/testify v1.3.0"

		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/google/go-cmp v0.2.0/go.mod"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/sergi/go-diff v1.0.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/testify v1.3.0/go.mod"
	)

	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

go-module_set_globals
SRC_URI+=" ${EGO_SUM_SRC_URI}"

src_prepare() {
	eapply_user
	rm licenses/*db || die
}

src_compile() {
	mkdir -p build-int build || die

	# Make a binary that will be used to generate licenses
	go build -o build-int ./... || die

	# Make a binary that will use fixed path for the db
	cp -v file_system_resources.go{,.bak} || die
	local share="${EROOT}/usr/share/licenseclassifier"
	sed -i "s@= lcRoot()@= \"${share}\", error(nil)@" file_system_resources.go || die
	go build -o build ./... || die

	# undo that change for tests
	mv -v file_system_resources.go{.bak,} || die

	build-int/license_serializer -output licenses || die
	build-int/license_serializer -forbidden -output licenses || die
}

src_test() {
	go test ./... || die
}

src_install() {
	# Install package data (this isn't the package license)
	insinto usr/share/licenseclassifier
	doins licenses/*

	dobin build/*
	einstalldocs
}
