# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/jzelinskie/faq"

EGO_VENDOR=(
	"github.com/alecthomas/chroma d7b2ed20a4989ab604703f61f86523560f8a6a87"
	"github.com/Azure/draft fdc29c553a45600ac4f795f3485d4bb9a80c7862"
	"github.com/BurntSushi/toml b26d9c308763d68093482582cea63d69be07a0f0"
	"github.com/cheekybits/is 68e9c0620927fb5427fda3708222d0edee89eae9"
	"github.com/clbanning/mxj 32282164326064599d3a83e53adcb9b318d78d90"
	"github.com/danwakefield/fnmatch cbb64ac3d964b81592e64f957ad53df015803288"
	"github.com/dlclark/regexp2 7632a260cbaf5e7594fc1544a503456ecd0827f1"
	"github.com/ghodss/yaml 0ca9ea5df5451ffdf184b4428c902747c2c11cd7"
	"github.com/globalsign/mgo efe0945164a7e582241f37ae8983c075f8f2e870"
	"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
	"github.com/jbrukh/bayesian bf3f261f9a9c61145c60d47665b0518cc32c774f"
	"github.com/sirupsen/logrus c155da19408a8799da419ed3eeb0cb5db0ad5dbc"
	"github.com/spf13/cobra ef82de70bb3f60c65fb8eebacbb2d122ef517385"
	"github.com/spf13/pflag 583c0c0531f06d5278b7d917446061adc344b5cd"
	"github.com/zeebo/bencode d522839ac797fc43269dae6a04a1f8be475a915d"
	"golang.org/x/crypto 1a580b3eff7814fc9b40602fd35256c63b50f491 github.com/golang/crypto"
	"golang.org/x/sys 7c87d13f8e835d2fb3a70a2912c811ed0c1d241b github.com/golang/sys"
	"gopkg.in/yaml.v2 5420a8b6744d3b0345ab293f6fcba19c978f1183 github.com/go-yaml/yaml"
)

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Format agnostic jQ"
HOMEPAGE="https://github.com/jzelinskie/faq"
SRC_URI="https://github.com/jzelinskie/faq/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-misc/jq
	dev-libs/oniguruma"

RESTRICT="test"

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" go install -v "${EGO_PN}" || die
	popd || die
}

src_install() {
	dobin bin/${PN}
	pushd src/${EGO_PN} || die
	dodoc README.md docs/examples.md
	popd || die
}
