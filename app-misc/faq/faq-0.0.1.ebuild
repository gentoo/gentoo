# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/jzelinskie/faq"

EGO_VENDOR=(
	"github.com/Azure/draft 53924464463d2474f410415f1310d2b95fb8965f"
	"github.com/BurntSushi/toml b26d9c308763d68093482582cea63d69be07a0f0"
	"github.com/ashb/jqrepl 70de3caa122cf7c7a737f28b666ab0d541560598"
	"github.com/clbanning/mxj eb2e8a1ed220896d2b16890436447a0eae496fae"
	"github.com/ghodss/yaml 0ca9ea5df5451ffdf184b4428c902747c2c11cd7"
	"github.com/globalsign/mgo baa28fcb8e7d5dfab92026c0920cb6c9ae72faa2"
	"github.com/inconshreveable/mousetrap 76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
	"github.com/jbrukh/bayesian bf3f261f9a9c61145c60d47665b0518cc32c774f"
	"github.com/sirupsen/logrus c155da19408a8799da419ed3eeb0cb5db0ad5dbc"
	"github.com/spf13/cobra a1f051bc3eba734da4772d60e2d677f47cf93ef4"
	"github.com/spf13/pflag e57e3eeb33f795204c1ca35f56c44f83227c6e66"
	"github.com/zeebo/bencode d522839ac797fc43269dae6a04a1f8be475a915d"
	"golang.org/x/crypto 88942b9c40a4c9d203b82b3731787b672d6e809b github.com/golang/crypto"
	"golang.org/x/sys 13d03a9a82fba647c21a0ef8fba44a795d0f0835 github.com/golang/sys"
	"gopkg.in/yaml.v2 86f5ed62f8a0ee96bd888d2efdfd6d4fb100a4eb github.com/go-yaml/yaml"
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

RESTRICT="test"

src_compile() {
	pushd src || die
	GOPATH="${S}" go install github.com/jzelinskie/faq
	popd || die
}

src_install() {
	dobin bin/${PN}
	pushd src/${EGO_PN} || die
	dodoc README.md docs/examples.md
	popd || die
}
