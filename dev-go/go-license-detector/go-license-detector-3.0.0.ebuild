# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Scan a source directory and report the license"
HOMEPAGE="https://github.com/src-d/go-license-detector"

EGO_VENDOR=(
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/dgryski/go-minhash 7fe510aff544"
	"github.com/ekzhu/minhash-lsh 5c06ee8586a1"
	"github.com/hhatto/gorst 7682c8a25108"
	"github.com/jbenet/go-context d14ea06fba99"
	"github.com/jdkato/prose v1.1.0"
	"github.com/kevinburke/ssh_config 0ff8514904a8"
	"github.com/mitchellh/go-homedir b8bc1bf76747"
	"github.com/montanaflynn/stats eeaced052adb"
	"github.com/pelletier/go-buffruneio v0.2.0"
	"github.com/pkg/errors v0.8.0"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/sergi/go-diff da645544ed44"
	"github.com/shogo82148/go-shuffle 59829097ff3b"
	"github.com/shurcooL/sanitized_anchor_name 86672fcb3f95"
	"github.com/spf13/pflag v1.0.0"
	"github.com/src-d/gcfg v1.3.0"
	"github.com/stretchr/testify v1.2.1"
	"github.com/xanzy/ssh-agent v0.2.0"
	"golang.org/x/crypto d9133f546934 github.com/golang/crypto"
	"golang.org/x/exp 072991165226 github.com/golang/exp"
	"golang.org/x/net f5dfe339be1d github.com/golang/net"
	"golang.org/x/sys 2b024373dcd9 github.com/golang/sys"
	"golang.org/x/text 4e4a3210bb54 github.com/golang/text"
	"gonum.org/v1/gonum 996b88e8f894 github.com/gonum/gonum"
	"gopkg.in/neurosnap/sentences.v1 v1.0.6 github.com/neurosnap/sentences"
	"gopkg.in/russross/blackfriday.v2 v2.0.1 github.com/russross/blackfriday"
	"gopkg.in/src-d/go-billy-siva.v4 v4.3.0 github.com/src-d/go-billy-siva"
	"gopkg.in/src-d/go-billy.v4 v4.3.0 github.com/src-d/go-billy"
	"gopkg.in/src-d/go-git.v4 v4.1.0 github.com/src-d/go-git"
	"gopkg.in/src-d/go-siva.v1 v1.5.0 github.com/src-d/go-siva"
	"gopkg.in/warnings.v0 v0.1.2 github.com/go-warnings/warnings"
)
SRC_URI="https://github.com/src-d/go-license-detector/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD BSD-2 MIT ISC"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	cd cmd/license-detector || die
	go build || die
}

src_install() {
	dobin cmd/license-detector/license-detector
}
