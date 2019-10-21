# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="detect licenses used in Go binaries"
HOMEPAGE="https://github.com/mitchellh/golicense"

EGO_VENDOR=(
	"github.com/360EntSecGroup-Skylar/excelize v1.4.0"
	"github.com/agext/levenshtein v1.2.1"
	"github.com/apparentlymart/go-textseg v1.0.0"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/dgryski/go-minhash 7fe510aff544"
	"github.com/ekzhu/minhash-lsh 5c06ee8586a1"
	"github.com/emirpasic/gods v1.12.0"
	"github.com/fatih/color v1.7.0"
	"github.com/golang/protobuf v1.2.0"
	"github.com/google/go-cmp v0.2.0"
	"github.com/google/go-github/v18 v18.2.0 github.com/google/go-github"
	"github.com/google/go-querystring v1.0.0"
	"github.com/gosuri/uilive ac356e6e42cd"
	"github.com/hashicorp/errwrap v1.0.0"
	"github.com/hashicorp/go-cleanhttp v0.5.0"
	"github.com/hashicorp/go-multierror v1.0.0"
	"github.com/hashicorp/hcl2 0467c0c38ca2"
	"github.com/hhatto/gorst ca9f730cac5b"
	"github.com/jbenet/go-context d14ea06fba99"
	"github.com/jdkato/prose v1.1.0"
	"github.com/kevinburke/ssh_config 81db2a75821e"
	"github.com/mattn/go-colorable v0.0.9"
	"github.com/mattn/go-isatty v0.0.4"
	"github.com/mitchellh/go-homedir v1.0.0"
	"github.com/mitchellh/go-spdx v0.1.0"
	"github.com/mitchellh/go-wordwrap ad45545899c7"
	"github.com/mohae/deepcopy c48cc78d4826"
	"github.com/montanaflynn/stats db72e6cae808"
	"github.com/pelletier/go-buffruneio v0.2.0"
	"github.com/pkg/errors v0.8.0"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/rsc/goversion v1.2.0"
	"github.com/sebdah/goldie 8784dd1ab561"
	"github.com/sergi/go-diff v1.0.0"
	"github.com/shogo82148/go-shuffle 27e6095f230d"
	"github.com/shurcooL/sanitized_anchor_name 86672fcb3f95"
	"github.com/src-d/gcfg v1.4.0"
	"github.com/stretchr/objx v0.1.1"
	"github.com/stretchr/testify v1.2.2"
	"github.com/xanzy/ssh-agent v0.2.0"
	"github.com/zclconf/go-cty 58bb2bc0302a"
	"golang.org/x/crypto 0709b304e793 github.com/golang/crypto"
	"golang.org/x/exp a3060d491354 github.com/golang/exp"
	"golang.org/x/net 8a410e7b638d github.com/golang/net"
	"golang.org/x/oauth2 d2e6202438be github.com/golang/oauth2"
	"golang.org/x/sys 2b024373dcd9 github.com/golang/sys"
	"golang.org/x/text v0.3.0 github.com/golang/text"
	"golang.org/x/tools a5b4c53f6e8b github.com/golang/tools"
	"gonum.org/v1/gonum e2f95e5c31f6 github.com/gonum/gonum"
	"google.golang.org/appengine v1.1.0 github.com/golang/appengine"
	"gopkg.in/neurosnap/sentences.v1 v1.0.6 github.com/neurosnap/sentences"
	"gopkg.in/russross/blackfriday.v2 v2.0.0 github.com/russross/blackfriday"
	"gopkg.in/src-d/go-billy-siva.v4 v4.2.2 github.com/src-d/go-billy-siva"
	"gopkg.in/src-d/go-billy.v4 v4.3.0 github.com/src-d/go-billy"
	"gopkg.in/src-d/go-git.v4 v4.7.0 github.com/src-d/go-git"
	"gopkg.in/src-d/go-license-detector.v2 da552ecf050b github.com/src-d/go-license-detector"
	"gopkg.in/src-d/go-siva.v1 v1.3.0 github.com/src-d/go-siva"
	"gopkg.in/warnings.v0 v0.1.2 github.com/go-warnings/warnings"
)

SRC_URI="https://github.com/mitchellh/golicense/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"

LICENSE="Apache-2.0 BSD ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	go build || die
}

src_install() {
	dobin golicense
	dodoc README.md
}
