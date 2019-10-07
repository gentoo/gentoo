# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_VENDOR=(
	"github.com/BurntSushi/locker a6e239ea1c69bff1cfdb20c4b73dadf52f784b6a"
	"github.com/BurntSushi/toml a368813c5e648fee92e5f6c30e3944ff9d5e8895"
	"github.com/PuerkitoBio/purell 0bcb03f4b4d0a9428594752bd2a3b9aa0a9d4bd4"
	"github.com/PuerkitoBio/urlesc de5bf2ad457846296e2031421a34e2568e304e35"
	"github.com/alecthomas/assert 405dbfeb8e38effee6e723317226e93fff912d06"
	"github.com/alecthomas/chroma 5d7fef2ae60b501bbf28d476c3f273b8017d8261"
	"github.com/alecthomas/colour 60882d9e27213e8552dcff6328914fe4c2b44bc9"
	"github.com/alecthomas/repr ead21651dde39fea129e6e4a612c675693d0f4ff"
	"github.com/bep/debounce 844797fa1dd9ba969d71b62797ff19d1e49d4eac"
	"github.com/bep/gitmap ecb6fe06dbfd6bb4225e7fda7dc15612ecc8d960"
	"github.com/bep/go-tocss 2abb118dc8688b6c7df44e12f4152c2bded9b19c"
	"github.com/chaseadamsio/goorgeous dcf1ef873b8987bf12596fe6951c48347986eb2f"
	"github.com/cpuguy83/go-md2man a65d4d2de4d5f7c74868dfa9b202a3c8be315aaa"
	"github.com/danwakefield/fnmatch cbb64ac3d964b81592e64f957ad53df015803288"
	"github.com/davecgh/go-spew 346938d642f2ec3594ed81d874461961cd0faa76"
	"github.com/disintegration/imaging dd50a3ee9985ccd313a2f03c398fcaedc96dc707"
	"github.com/dlclark/regexp2 487489b64fb796de2e55f4e8a4ad1e145f80e957"
	"github.com/eknkc/amber cdade1c073850f4ffc70a829e31235ea6892853b"
	"github.com/fortytw2/leaktest a5ef70473c97b71626b9abeda80ee92ba2a7de9e"
	"github.com/fsnotify/fsnotify 629574ca2a5df945712d3079857300b5e4da0236"
	"github.com/gobwas/glob 5ccd90ef52e1e632236f7326478d4faa74f99438"
	"github.com/gorilla/websocket ea4d1f681babbce9545c9c5f3d5194a789c89f5b"
	"github.com/hashicorp/go-immutable-radix 7f3cd4390caab3250a57f30efdb2a65dd7649ecf"
	"github.com/hashicorp/golang-lru 0fb14efe8c47ae851c0034ed7a448854d3d34cf3"
	"github.com/hashicorp/hcl ef8a98b0bbce4a65b5aa4c368430a80ddc533168"
	"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
	"github.com/jdkato/prose 20d3663d4bc9dd10d75abcde9d92e04b4861c674"
	"github.com/kyokomi/emoji 2e9a9507333f3ee28f3fab88c2c3aba34455d734"
	"github.com/magefile/mage 2f974307b636f59c13b88704cf350a4772fef271"
	"github.com/magiconair/properties c2353362d570a7bfa228149c62842019201cfb71"
	"github.com/markbates/inflect a12c3aec81a6a938bf584a4bac567afed9256586"
	"github.com/mattn/go-isatty 0360b2af4f38e8d38c7fce2a9f4e702702d73a39"
	"github.com/mattn/go-runewidth 9e777a8366cce605130a531d2cd6363d07ad7317"
	"github.com/miekg/mmark fd2f6c1403b37925bd7fe13af05853b8ae58ee5f"
	"github.com/mitchellh/hashstructure 2bca23e0e452137f789efbc8610126fd8b94f73b"
	"github.com/mitchellh/mapstructure f15292f7a699fcc1a38a80977f80a046874ba8ac"
	"github.com/muesli/smartcrop f6ebaa786a12a0fdb2d7c6dee72808e68c296464"
	"github.com/nicksnyder/go-i18n 0dc1626d56435e9d605a29875701721c54bc9bbd"
	"github.com/olekukonko/tablewriter d4647c9c7a84d847478d890b816b7d8b62b0b279"
	"github.com/pelletier/go-toml c01d1270ff3e442a8a57cddc1c92dc1138598194"
	"github.com/pmezard/go-difflib 792786c7400a136282c1664665ae0a8db921c6c2"
	"github.com/russross/blackfriday 46c73eb196baff5bb07288f245b223bd1a30fba6"
	"github.com/sanity-io/litter ae543b7ba8fd6af63e4976198f146e1348ae53c1"
	"github.com/sergi/go-diff 1744e2970ca51c86172c8190fadad617561ed6e7"
	"github.com/shurcooL/sanitized_anchor_name 86672fcb3f950f35f2e675df2240550f2a50762f"
	"github.com/spf13/afero 787d034dfe70e44075ccc060d346146ef53270ad"
	"github.com/spf13/cast 8965335b8c7107321228e3e3702cab9832751bac"
	"github.com/spf13/cobra a1f051bc3eba734da4772d60e2d677f47cf93ef4"
	"github.com/spf13/fsync 12a01e648f05a938100a26858d2d59a120307a18"
	"github.com/spf13/jwalterweatherman 7c0cea34c8ece3fbeb2b27ab9b59511d360fb394"
	"github.com/spf13/nitro 24d7ef30a12da0bdc5e2eb370a79c659ddccf0e8"
	"github.com/spf13/pflag 583c0c0531f06d5278b7d917446061adc344b5cd"
	"github.com/spf13/viper 907c19d40d9a6c9bb55f040ff4ae45271a4754b9"
	"github.com/stretchr/testify f35b8ab0b5a2cef36673838d662e249dd9c94686"
	"github.com/tdewolff/minify 8d72a4127ae33b755e95bffede9b92e396267ce2"
	"github.com/tdewolff/parse d739d6fccb0971177e06352fea02d3552625efb1"
	"github.com/wellington/go-libsass 615eaa47ef794d037c1906a0eb7bf85375a5decf"
	"github.com/yosssi/ace ea038f4770b6746c3f8f84f14fa60d9fe1205b56"
	"golang.org/x/image f315e440302883054d0c2bd85486878cb4f8572c github.com/golang/image"
	"golang.org/x/net f4c29de78a2a91c00474a2e689954305c350adf9 github.com/golang/net"
	"golang.org/x/sync 1d60e4601c6fd243af51cc01ddf169918a5407ca github.com/golang/sync"
	"golang.org/x/sys 2be389f392cd91df245b41638f818a1c041f0c08 github.com/golang/sys"
	"golang.org/x/text cb6730876b985e110843c1842a7a63a63677cf08 github.com/golang/text"
	"gopkg.in/yaml.v2 5420a8b6744d3b0345ab293f6fcba19c978f1183 github.com/go-yaml/yaml" )

inherit golang-build golang-vcs-snapshot bash-completion-r1

EGO_PN="github.com/gohugoio/hugo"
GIT_COMMIT="456f5476cf9bf96c558448372058130fee1f9330"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A Fast and Flexible Static Site Generator built with love in Go"
HOMEPAGE="https://gohugo.io https://github.com/gohugoio/hugo"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="+sass"

RESTRICT="test"

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go install -mod vendor -v -ldflags "-X ${EGO_PN}/hugolib.CommitHash=${GIT_COMMIT}" $(usex sass "-tags extended" "") || die
	popd || die
	bin/hugo gen man || die
	bin/hugo gen autocomplete --completionfile hugo || die
}

src_install() {
	dobin bin/*
	dobashcomp hugo || die
	doman man/*
	dodoc src/${EGO_PN}/README.md
}
