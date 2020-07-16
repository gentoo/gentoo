# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
DESCRIPTION="Google Drive client for the commandline"
HOMEPAGE="https://github.com/odeke-em/drive"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
IUSE=""
EGO_PN="${HOMEPAGE#*//}"
EGIT_COMMIT="v${PV}"
EGO_VENDOR=(
	"cloud.google.com/go ce902a9872e454f175f5e84ceae12514cd33953f github.com/googleapis/google-cloud-go"
	"github.com/boltdb/bolt fd01fc79c553a8e99d512a07e8e0c63d4a3ccfc5"
	"github.com/cheggaaa/pb ca06a0216aa3e3429a8b9667219931c48417bced"
	"github.com/codegangsta/inject 33e0aa1cb7c019ccc3fbe049a8262a6403d30504"
	"github.com/golang/groupcache 869f871628b6baa9cfbc11732cdf6546b17c1298"
	"github.com/golang/protobuf 822fe56949f5d56c9e2f02367c657e0e9b4d27d1"
	"github.com/go-martini/martini 22fa46961aabd2665cf3f1343b146d20028f5071"
	"github.com/googleapis/gax-go 7cb21a99a18735dde62f5d3cc0244f3f35bd9515"
	"github.com/martini-contrib/binding 05d3e151b6cf34dacac6306226a33db68459a3b5"
	"github.com/mattn/go-isatty bf9a1dea1961e1d831824fb135332bfb8c10e8b8"
	"github.com/mattn/go-runewidth 703b5e6b11ae25aeb2af9ebb5d5fdf8fa2575211"
	"github.com/odeke-em/cache baf8e436bc97557118cb0bf118ab8ac6aeeda381"
	"github.com/odeke-em/cli-spinner 610063bb4aeef25f7645b3e6080456655ec0fb33"
	"github.com/odeke-em/command 91ca5ec5e9a1bc2668b1ccbe0967e04a349e3561"
	"github.com/odeke-em/exponential-backoff 96e25d36ae36ad09ac02cbfe653b44c4043a8e09"
	"github.com/odeke-em/extractor 801861aedb854c7ac5e1329e9713023e9dc2b4d4"
	"github.com/odeke-em/go-utils e8ebaed0777a55fa09937617a157dd51386136c2"
	"github.com/odeke-em/go-uuid b211d769a9aaba5b2b8bdbab5de3c227116f3c39"
	"github.com/odeke-em/log 8d60a6917853243fd746612e6ba47843a794fa82"
	"github.com/odeke-em/meddler d2b51d2b40e786ab5f810d85e65b96404cf33570"
	"github.com/odeke-em/namespace 0ab79ba44f1328b1ec75ea985ad5c338ba3d56a6"
	"github.com/odeke-em/pretty-words 9d37a7fcb4ae6f94b288d371938482994458cecb"
	"github.com/odeke-em/rsc 6ad75e1e26192f3d140b6486deb99c9dbd289846"
	"github.com/odeke-em/semalim 9c88bf5f9156ed06ec5110a705d41b8580fd96f7"
	"github.com/odeke-em/statos 292960a201e2310a667eac7796f4e11cd51021a3"
	"github.com/skratchdot/open-golang 79abb63cd66e41cb1473e26d11ebdcd68b04c8e5"
	"golang.org/x/crypto 227b76d455e791cb042b03e633e2f7fbcfdf74a5 github.com/golang/crypto"
	"golang.org/x/net a8b05e9114ab0cb08faec337c959aed24b68bf50 github.com/golang/net"
	"golang.org/x/oauth2 0f29369cfe4552d0e4bcddc57cc75f4d7e672a33 github.com/golang/oauth2"
	"golang.org/x/sys b4ddaad3f8a36719f2b8bc6486c14cc468ca2bb5 github.com/golang/sys"
	"golang.org/x/text 3d0f7978add91030e5e8976ff65ccdd828286cba github.com/golang/text"
	"google.golang.org/api 634b73c1f50be990f1ba97c3f325fb7f88b13775 github.com/googleapis/google-api-go-client"
	"google.golang.org/genproto f660b865573183437d2d868f703fe88bb8af0b55 github.com/googleapis/go-genproto"
	"google.golang.org/grpc e2cfd1c28f4a49333263cf65123aae57b081750b github.com/grpc/grpc-go"
	"go.opencensus.io 65310139a05de5c10077b75ac45eac743aa01214 github.com/census-instrumentation/opencensus-go"
)
inherit golang-vcs-snapshot

SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

src_compile() {
	GOPATH="${S}" \
		go install -v -work -x ${EGO_BUILD_FLAGS} \
		"${EGO_PN}"/{cmd/drive,drive-server} || die
}

src_install() {
	dodoc "${S}/src/${EGO_PN}/README.md"
	dobin "${S}/bin/drive"{,-server}
}
