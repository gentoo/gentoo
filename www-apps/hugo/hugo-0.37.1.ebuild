# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_VENDOR=( "github.com/BurntSushi/toml a368813c5e648fee92e5f6c30e3944ff9d5e8895"
	"github.com/PuerkitoBio/purell 0bcb03f4b4d0a9428594752bd2a3b9aa0a9d4bd4"
	"github.com/PuerkitoBio/urlesc de5bf2ad457846296e2031421a34e2568e304e35"
	"github.com/alecthomas/chroma 563aadc53c53292c4c1def1b0a547be498bba83e"
	"github.com/bep/gitmap de8030ebafb76c6e84d50ee6d143382637c00598"
	"github.com/chaseadamsio/goorgeous dcf1ef873b8987bf12596fe6951c48347986eb2f"
	"github.com/cpuguy83/go-md2man a65d4d2de4d5f7c74868dfa9b202a3c8be315aaa"
	"github.com/danwakefield/fnmatch cbb64ac3d964b81592e64f957ad53df015803288"
	"github.com/davecgh/go-spew 346938d642f2ec3594ed81d874461961cd0faa76"
	"github.com/disintegration/imaging dd50a3ee9985ccd313a2f03c398fcaedc96dc707"
	"github.com/dlclark/regexp2 487489b64fb796de2e55f4e8a4ad1e145f80e957"
	"github.com/eknkc/amber cdade1c073850f4ffc70a829e31235ea6892853b"
	"github.com/fortytw2/leaktest 7dad53304f9614c1c365755c1176a8e876fee3e8"
	"github.com/fsnotify/fsnotify 629574ca2a5df945712d3079857300b5e4da0236"
	"github.com/gobwas/glob 5ccd90ef52e1e632236f7326478d4faa74f99438"
	"github.com/gorilla/websocket ea4d1f681babbce9545c9c5f3d5194a789c89f5b"
	"github.com/hashicorp/go-immutable-radix 7f3cd4390caab3250a57f30efdb2a65dd7649ecf"
	"github.com/hashicorp/golang-lru 0fb14efe8c47ae851c0034ed7a448854d3d34cf3"
	"github.com/hashicorp/hcl 23c074d0eceb2b8a5bfdbb271ab780cde70f05a8"
	"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
	"github.com/jdkato/prose 20d3663d4bc9dd10d75abcde9d92e04b4861c674"
	"github.com/kyokomi/emoji 7e06b236c489543f53868841f188a294e3383eab"
	"github.com/magefile/mage 2f974307b636f59c13b88704cf350a4772fef271"
	"github.com/magiconair/properties c3beff4c2358b44d0493c7dda585e7db7ff28ae6"
	"github.com/markbates/inflect a12c3aec81a6a938bf584a4bac567afed9256586"
	"github.com/mattn/go-runewidth 9e777a8366cce605130a531d2cd6363d07ad7317"
	"github.com/miekg/mmark fd2f6c1403b37925bd7fe13af05853b8ae58ee5f"
	"github.com/mitchellh/mapstructure a4e142e9c047c904fa2f1e144d9a84e6133024bc"
	"github.com/muesli/smartcrop 1db484956b9ef929344e51701299a017beefdaaa"
	"github.com/nicksnyder/go-i18n 0dc1626d56435e9d605a29875701721c54bc9bbd"
	"github.com/olekukonko/tablewriter b8a9be070da40449e501c3c4730a889e42d87a9e"
	"github.com/pelletier/go-toml acdc4509485b587f5e675510c4f2c63e90ff68a8"
	"github.com/pmezard/go-difflib 792786c7400a136282c1664665ae0a8db921c6c2"
	"github.com/russross/blackfriday 55d61fa8aa702f59229e6cff85793c22e580eaf5"
	"github.com/shurcooL/sanitized_anchor_name 86672fcb3f950f35f2e675df2240550f2a50762f"
	"github.com/spf13/afero bb8f1927f2a9d3ab41c9340aa034f6b803f4359c"
	"github.com/spf13/cast 8965335b8c7107321228e3e3702cab9832751bac"
	"github.com/spf13/cobra be77323fc05148ef091e83b3866c0d47c8e74a8b"
	"github.com/spf13/fsync 12a01e648f05a938100a26858d2d59a120307a18"
	"github.com/spf13/jwalterweatherman 7c0cea34c8ece3fbeb2b27ab9b59511d360fb394"
	"github.com/spf13/nitro 24d7ef30a12da0bdc5e2eb370a79c659ddccf0e8"
	"github.com/spf13/pflag e57e3eeb33f795204c1ca35f56c44f83227c6e66"
	"github.com/spf13/viper 25b30aa063fc18e48662b86996252eabdcf2f0c7"
	"github.com/stretchr/testify 12b6f73e6084dad08a7c6e575284b177ecafbc71"
	"github.com/yosssi/ace ea038f4770b6746c3f8f84f14fa60d9fe1205b56"
	"golang.org/x/image 12117c17ca67ffa1ce22e9409f3b0b0a93ac08c7 github.com/golang/image"
	"golang.org/x/net 136a25c244d3019482a795d728110278d6ba09a4 github.com/golang/net"
	"golang.org/x/sync fd80eb99c8f653c847d294a001bdf2a3a6f768f5 github.com/golang/sync"
	"golang.org/x/sys 37707fdb30a5b38865cfb95e5aab41707daec7fd github.com/golang/sys"
	"golang.org/x/text 4e4a3210bb54bb31f6ab2cdca2edcc0b50c420c1 github.com/golang/text"
	"gopkg.in/yaml.v2 d670f9405373e636a5a2765eea47fac0c9bc91a4 github.com/go-yaml/yaml" )

inherit golang-build golang-vcs-snapshot bash-completion-r1

EGO_PN="github.com/gohugoio/hugo"
GIT_COMMIT="f414966b942b5aad75565bee6c644782a07f0658"
ARCHIVE_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="A Fast and Flexible Static Site Generator built with love in Go"
HOMEPAGE="https://gohugo.io https://github.com/gohugoio/hugo"
SRC_URI="${ARCHIVE_URI}
	${EGO_VENDOR_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go install -ldflags "-X ${EGO_PN}/hugolib.CommitHash=${GIT_COMMIT}"|| die
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
