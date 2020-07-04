# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=( "github.com/pkg/profile f6fe06335df110bcf1ed6d4e852b760bfc15beee"
	     "gopkg.in/h2non/filetype.v1 cc14fdc9ca0e4c2bafad7458f6ff79fd3947cfbb github.com/h2non/filetype"
	     "gopkg.in/mattn/go-isatty 6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c github.com/mattn/go-isatty"
	     "github.com/pkg/xattr dd870b5cfebab49617ea0c1da6176474e8a52bf4"
	     "golang.org/x/text 6f44c5a2ea40ee3593d98cdcc905cc1fdaa660e2 github.com/golang/text"
	     "github.com/mitchellh/go-homedir af06845cf3004701891bf4fdb884bfe4920b3727"
	     "golang.org/x/sys 81d4e9dc473e5e8c933f2aaeba2a3d81efb9aed2 github.com/golang/sys"
	     "github.com/cheggaaa/pb f907f6f5dd81f77c2bbc1cde92e4c5a04720cb11"
	     "github.com/mattn/go-runewidth 3ee7d812e62a0804a7d0a324e0249ca2db3476d3"
	     "github.com/mattn/go-colorable 3a70a971f94a22f2fa562ffcc7a0eb45f5daf045"
	     "github.com/dustin/go-humanize 9f541cc9db5d55bce703bd99987c9d5cb8eea45e"
	     "github.com/fatih/color 5b77d2a35fb0ede96d138fc9a99f5c9b6aef11b4"
	     "github.com/hashicorp/go-version d40cf49b3a77bba84a7afdbd7f1dc295d114efb1"
	     "github.com/inconshreveable/go-update 8152e7eb6ccf8679a64582a66b78519688d156ad"
	     "github.com/mattn/go-isatty 6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
	     "golang.org/x/net b630fd6fe46bcfc98f989005d8b8ec1400e60a6e github.com/golang/net"
	     "golang.org/x/crypto a5d413f7728c81fb97d96a2b722368945f651e78 github.com/golang/crypto"
	     "github.com/segmentio/go-prompt f0d19b6901ade831d5a3204edc0d6a7d6457fbb2"
	     "github.com/rjeczalik/notify 69d839f37b13a8cb7a78366f7633a4071cb43be7"
	     "github.com/posener/complete 3ef9b31a6a0613ae832e7ecf208374027c3b2343"
	     "github.com/minio/sha256-simd 05b4dd3047e5d6e86cb4e0477164b850cd896261"
	     "github.com/hashicorp/go-multierror 886a7fbe3eb1c874d46f623bfa70af45f425b3d1"
	     "github.com/hashicorp/errwrap 8a6fb523712970c966eefc6b39ed2c5e74880354"
	     "github.com/minio/cli 8683fa7fef37cc8cb092f47bdb6b403e0049f9ee"
	     "github.com/minio/minio-go 5d20267d970d9e514bbcb88b37b059bb5321ff60"
	     "github.com/minio/minio 0250f7de678bbca5ad8bbfd50e2f65133feb06e2"
	     "github.com/howeyc/gopass bf9dde6d0d2c004a008c27aaee91170c786f6db8"
	     "gopkg.in/ini.v1 c85607071cf08ca1adaf48319cd1aa322e81d8c1 github.com/go-ini/ini"
	     "github.com/minio/minio-go/v6 5d20267d970d9e514bbcb88b37b059bb5321ff60 github.com/minio/minio-go"
)

inherit golang-build golang-vcs-snapshot

MY_PV="$(ver_cut 1-3)T$(ver_cut 4-7)Z"
MY_PV=${MY_PV//./-}

EGIT_COMMIT="c352cadd4be2c6bed64884c78d1e8a8ac6efaf3f"

EGO_PN="github.com/minio/mc"

DESCRIPTION="Minio client provides alternatives for ls, cat on cloud storage and filesystems"
HOMEPAGE="https://github.com/minio/mc"
SRC_URI="https://${EGO_PN}/archive/RELEASE.${MY_PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!!app-misc/mc"

src_prepare() {
	default

	pushd src/${EGO_PN} || die

	sed -i -e "s/time.Now().UTC().Format(time.RFC3339)/\"${VERSION}\"/"\
		-e "s/-s //"\
		-e "/time/d"\
		-e "s/+ commitID()/+ \"${EGIT_COMMIT}\"/"\
		buildscripts/gen-ldflags.go || die

	popd || die

}

src_compile() {
	unset XDG_CACHE_HOME

	pushd src/${EGO_PN} || die

	MC_RELEASE="${MY_PV}"
	GO111MODULE=on GOPATH="${S}" go build --ldflags "$(go run buildscripts/gen-ldflags.go)" -o ${PN} || die
	popd || die

}

src_install() {
	pushd src/${EGO_PN} || die
	dodoc -r README.md CONTRIBUTING.md docs
	dobin mc
	popd  || die
}
