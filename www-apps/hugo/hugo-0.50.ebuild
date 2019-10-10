# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_VENDOR=(
	"github.com/PuerkitoBio/purell v1.1.0"
	"github.com/PuerkitoBio/urlesc de5bf2ad4578"
	"github.com/alecthomas/assert 405dbfeb8e38"
	"github.com/alecthomas/chroma v0.5.0"
	"github.com/alecthomas/colour 60882d9e2721"
	"github.com/alecthomas/repr 117648cd9897"
	"github.com/bep/debounce v1.1.0"
	"github.com/bep/gitmap v1.0.0"
	"github.com/bep/go-tocss v0.5.0"
	"github.com/chaseadamsio/goorgeous v1.1.0"
	"github.com/cpuguy83/go-md2man v1.0.8"
	"github.com/danwakefield/fnmatch cbb64ac3d964"
	"github.com/disintegration/imaging v1.5.0"
	"github.com/dlclark/regexp2 v1.1.6"
	"github.com/eknkc/amber cdade1c07385"
	"github.com/fortytw2/leaktest v1.2.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/gobwas/glob v0.2.3"
	"github.com/gorilla/websocket v1.4.0"
	"github.com/hashicorp/go-immutable-radix v1.0.0"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/jdkato/prose v1.1.0"
	"github.com/kr/pretty v0.1.0"
	"github.com/kyokomi/emoji v1.5.1"
	"github.com/magefile/mage v1.4.0"
	"github.com/markbates/inflect v1.0.0"
	"github.com/mattn/go-isatty v0.0.4"
	"github.com/mattn/go-runewidth v0.0.3"
	"github.com/miekg/mmark v1.3.6"
	"github.com/mitchellh/hashstructure v1.0.0"
	"github.com/mitchellh/mapstructure v1.0.0"
	"github.com/muesli/smartcrop f6ebaa786a12"
	"github.com/nfnt/resize 83c6a9932646"
	"github.com/nicksnyder/go-i18n v1.10.0"
	"github.com/olekukonko/tablewriter d4647c9c7a84"
	"github.com/pkg/errors v0.8.0"
	"github.com/russross/blackfriday 46c73eb196ba"
	"github.com/sanity-io/litter v1.1.0"
	"github.com/sergi/go-diff v1.0.0"
	"github.com/shurcooL/sanitized_anchor_name 86672fcb3f95"
	"github.com/spf13/afero v1.1.2"
	"github.com/spf13/cast v1.3.0"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/fsync 12a01e648f05"
	"github.com/spf13/jwalterweatherman 94f6ae3ed3bc"
	"github.com/spf13/nitro 24d7ef30a12d"
	"github.com/spf13/pflag v1.0.2"
	"github.com/spf13/viper v1.2.0"
	"github.com/stretchr/testify f2347ac6c9c9"
	"github.com/tdewolff/minify v2.3.6"
	"github.com/tdewolff/parse v2.3.3"
	"github.com/wellington/go-libsass 615eaa47ef79"
	"github.com/yosssi/ace v0.0.5"
	"golang.org/x/image c73c2afc3b81 github.com/golang/image"
	"golang.org/x/net 161cd47e91fd github.com/golang/net"
	"golang.org/x/sync 1d60e4601c6f github.com/golang/sync"
	"golang.org/x/sys d0be0721c37e github.com/golang/sys"
	"golang.org/x/text v0.3.0 github.com/golang/text"
	"gopkg.in/check.v1 788fd7840127 github.com/go-check/check"
	"gopkg.in/yaml.v2 v2.2.1 github.com/go-yaml/yaml"
	"github.com/joho/godotenv v1.3.0"
	"github.com/gobuffalo/envy v1.6.4"
	"github.com/tdewolff/parse fced451e0bed"
	"github.com/BurntSushi/locker a6e239ea1c69bff1cfdb20c4b73dadf52f784b6a"
	"github.com/BurntSushi/toml a368813c5e648fee92e5f6c30e3944ff9d5e8895"
	"github.com/hashicorp/golang-lru 0fb14efe8c47ae851c0034ed7a448854d3d34cf3"
	"github.com/hashicorp/hcl ef8a98b0bbce4a65b5aa4c368430a80ddc533168"
	"github.com/magiconair/properties c2353362d570a7bfa228149c62842019201cfb71"
	"github.com/pelletier/go-toml c01d1270ff3e442a8a57cddc1c92dc1138598194"
)

inherit go-module bash-completion-r1

GO_DEPEND=">=dev-lang/go-1.11"
EGO_PN="github.com/gohugoio/hugo"
GIT_COMMIT="456f5476cf9bf96c558448372058130fee1f9330"
KEYWORDS="~amd64"

DESCRIPTION="The world's fastest framework for building websites"
HOMEPAGE="https://gohugo.io https://github.com/gohugoio/hugo"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(go-module_vendor_uris)"
LICENSE="Apache-2.0 Unlicense BSD BSD-2 MPL-2.0"
SLOT="0"
IUSE="+sass"

RESTRICT="test"

src_compile() {
	mkdir -pv bin || die
	go build -ldflags \
		"-X ${EGO_PN}/hugolib.CommitHash=${GIT_COMMIT}" \
		$(usex sass "-tags extended" "") -o "${S}/bin/hugo" || die
	bin/hugo gen man || die
	bin/hugo gen autocomplete --completionfile hugo || die
}

src_install() {
	dobin bin/*
	dobashcomp hugo || die
	doman man/*
	dodoc README.md
}
