# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KEYWORDS="amd64"
DESCRIPTION="Google Drive client for the commandline"
HOMEPAGE="https://github.com/odeke-em/drive"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
IUSE=""
EGO_PN="${HOMEPAGE#*//}"
EGIT_COMMIT="v${PV}"
EGO_VENDOR=(
	"cloud.google.com/go a5e721bf760c8055ea3ae8b732da1dc6a10fc3f9 github.com/GoogleCloudPlatform/gcloud-golang"
	"github.com/boltdb/bolt fa5367d20c994db73282594be0146ab221657943"
	"github.com/cheggaaa/pb 657164d0228d6bebe316fdf725c69f131a50fb10"
	"github.com/codegangsta/inject 33e0aa1cb7c019ccc3fbe049a8262a6403d30504"
	"github.com/go-martini/martini 22fa46961aabd2665cf3f1343b146d20028f5071"
	"github.com/golang/protobuf 11b8df160996e00fd4b55cbaafb3d84ec6d50fa8"
	"github.com/googleapis/gax-go 317e0006254c44a0ac427cc52a0e083ff0b9622f"
	"github.com/martini-contrib/binding 05d3e151b6cf34dacac6306226a33db68459a3b5"
	"github.com/mattn/go-isatty fc9e8d8ef48496124e79ae0df75490096eccf6fe"
	"github.com/mattn/go-runewidth 97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
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
	"github.com/skratchdot/open-golang 75fb7ed4208cf72d323d7d02fd1a5964a7a9073c"
	"golang.org/x/crypto faadfbdc035307d901e69eea569f5dda451a3ee3 github.com/golang/crypto"
	"golang.org/x/net 859d1a86bb617c0c20d154590c3c5d3fcb670b07 github.com/golang/net"
	"golang.org/x/oauth2 13449ad91cb26cb47661c1b080790392170385fd github.com/golang/oauth2"
	"golang.org/x/text 14c0d48ead0cd47e3104ada247d91be04afc7a5a github.com/golang/text"
	"google.golang.org/api 39c3dd417c5a443607650f18e829ad308da08dd2 github.com/google/google-api-go-client"
	"google.golang.org/genproto 595979c8a7bf586b2d293fb42246bf91a0b893d9 github.com/google/go-genproto"
	"google.golang.org/grpc bb78878767b96d411e740439ac820f118e95ae2f github.com/grpc/grpc-go"
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
