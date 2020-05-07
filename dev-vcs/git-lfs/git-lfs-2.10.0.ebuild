# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/${PN}/${PN}"

inherit golang-base go-module

EGO_SUM=(
        "github.com/alexbrainman/sspi v0.0.0-20180125232955-4729b3d4d858"
        "github.com/alexbrainman/sspi v0.0.0-20180125232955-4729b3d4d858/go.mod"
        "github.com/avast/retry-go v2.4.2+incompatible"
        "github.com/avast/retry-go v2.4.2+incompatible/go.mod"
        "github.com/creack/pty v1.1.7"
        "github.com/creack/pty v1.1.7/go.mod"
        "github.com/davecgh/go-spew v1.1.1"
        "github.com/davecgh/go-spew v1.1.1/go.mod"
        "github.com/dpotapov/go-spnego v0.0.0-20190506202455-c2c609116ad0"
        "github.com/dpotapov/go-spnego v0.0.0-20190506202455-c2c609116ad0/go.mod"
        "github.com/git-lfs/gitobj v1.4.1"
        "github.com/git-lfs/gitobj v1.4.1/go.mod"
        "github.com/git-lfs/go-netrc v0.0.0-20180525200031-e0e9ca483a18"
        "github.com/git-lfs/go-netrc v0.0.0-20180525200031-e0e9ca483a18/go.mod"
        "github.com/git-lfs/go-ntlm v0.0.0-20190307203151-c5056e7fa066"
        "github.com/git-lfs/go-ntlm v0.0.0-20190307203151-c5056e7fa066/go.mod"
        "github.com/git-lfs/go-ntlm v0.0.0-20190401175752-c5056e7fa066"
        "github.com/git-lfs/go-ntlm v0.0.0-20190401175752-c5056e7fa066/go.mod"
        "github.com/git-lfs/wildmatch v1.0.2"
        "github.com/git-lfs/wildmatch v1.0.2/go.mod"
        "github.com/git-lfs/wildmatch v1.0.4"
        "github.com/git-lfs/wildmatch v1.0.4/go.mod"
        "github.com/hashicorp/go-uuid v1.0.1"
        "github.com/hashicorp/go-uuid v1.0.1/go.mod"
        "github.com/inconshreveable/mousetrap v1.0.0"
        "github.com/inconshreveable/mousetrap v1.0.0/go.mod"
        "github.com/jcmturner/gofork v0.0.0-20190328161633-dc7c13fece03/go.mod"
        "github.com/jcmturner/gofork v1.0.0"
        "github.com/jcmturner/gofork v1.0.0/go.mod"
        "github.com/jcmturner/gokrb5 v7.3.0+incompatible"
        "github.com/jcmturner/gokrb5 v7.3.0+incompatible/go.mod"
        "github.com/kr/pty v1.1.8"
        "github.com/kr/pty v1.1.8/go.mod"
        "github.com/mattn/go-isatty v0.0.4"
        "github.com/mattn/go-isatty v0.0.4/go.mod"
        "github.com/olekukonko/ts v0.0.0-20171002115256-78ecb04241c0"
        "github.com/olekukonko/ts v0.0.0-20171002115256-78ecb04241c0/go.mod"
        "github.com/pkg/errors v0.0.0-20170505043639-c605e284fe17"
        "github.com/pkg/errors v0.0.0-20170505043639-c605e284fe17/go.mod"
        "github.com/pmezard/go-difflib v1.0.0"
        "github.com/pmezard/go-difflib v1.0.0/go.mod"
        "github.com/rubyist/tracerx v0.0.0-20170927163412-787959303086"
        "github.com/rubyist/tracerx v0.0.0-20170927163412-787959303086/go.mod"
        "github.com/spf13/cobra v0.0.3"
        "github.com/spf13/cobra v0.0.3/go.mod"
        "github.com/spf13/pflag v1.0.3"
        "github.com/spf13/pflag v1.0.3/go.mod"
        "github.com/ssgelm/cookiejarparser v1.0.1"
        "github.com/ssgelm/cookiejarparser v1.0.1/go.mod"
        "github.com/stretchr/testify v1.2.2"
        "github.com/stretchr/testify v1.2.2/go.mod"
        "github.com/xeipuuv/gojsonpointer v0.0.0-20180127040702-4e3ac2762d5f"
        "github.com/xeipuuv/gojsonpointer v0.0.0-20180127040702-4e3ac2762d5f/go.mod"
        "github.com/xeipuuv/gojsonreference v0.0.0-20180127040603-bd5ef7bd5415"
        "github.com/xeipuuv/gojsonreference v0.0.0-20180127040603-bd5ef7bd5415/go.mod"
        "github.com/xeipuuv/gojsonschema v0.0.0-20170210233622-6b67b3fab74d"
        "github.com/xeipuuv/gojsonschema v0.0.0-20170210233622-6b67b3fab74d/go.mod"
        "golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2"
        "golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
        "golang.org/x/crypto v0.0.0-20190426145343-a29dc8fdc734"
        "golang.org/x/crypto v0.0.0-20190426145343-a29dc8fdc734/go.mod"
        "golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3"
        "golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
        "golang.org/x/net v0.0.0-20191027093000-83d349e8ac1a"
        "golang.org/x/net v0.0.0-20191027093000-83d349e8ac1a/go.mod"
        "golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4"
        "golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
        "golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a"
        "golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
        "golang.org/x/sys v0.0.0-20190412213103-97732733099d"
        "golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
        "golang.org/x/text v0.3.0"
        "golang.org/x/text v0.3.0/go.mod"
        "gopkg.in/jcmturner/aescts.v1 v1.0.1"
        "gopkg.in/jcmturner/aescts.v1 v1.0.1/go.mod"
        "gopkg.in/jcmturner/dnsutils.v1 v1.0.1"
        "gopkg.in/jcmturner/dnsutils.v1 v1.0.1/go.mod"
        "gopkg.in/jcmturner/goidentity.v3 v3.0.0"
        "gopkg.in/jcmturner/goidentity.v3 v3.0.0/go.mod"
        "gopkg.in/jcmturner/gokrb5.v5 v5.3.0"
        "gopkg.in/jcmturner/gokrb5.v5 v5.3.0/go.mod"
        "gopkg.in/jcmturner/gokrb5.v7 v7.3.0"
        "gopkg.in/jcmturner/gokrb5.v7 v7.3.0/go.mod"
        "gopkg.in/jcmturner/rpc.v0 v0.0.2"
        "gopkg.in/jcmturner/rpc.v0 v0.0.2/go.mod"
        "gopkg.in/jcmturner/rpc.v1 v1.1.0"
        "gopkg.in/jcmturner/rpc.v1 v1.1.0/go.mod"
        )
go-module_set_globals

if [[ ${PV} == *9999 ]]; then
	inherit golang-vcs
	# Upstream deps for testing change to fast to track them here.
	RESTRICT="test"
else
	SRC_URI="
		https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		test? ( ${EGO_SUM_SRC_URI} )
	"
	KEYWORDS="amd64 ~amd64-linux ~x86-linux"
fi

HOMEPAGE="https://git-lfs.github.com/"
DESCRIPTION="Command line extension and specification for managing large files with git"

LICENSE="Apache-2.0 BSD BSD-2 BSD-4 ISC MIT"
SLOT="0"
IUSE="doc test"

RESTRICT="!test? ( test )"

BDEPEND="dev-lang/go
	doc? ( app-text/ronn )"
RDEPEND="dev-vcs/git"

src_compile() {
	set -- go build \
		-ldflags="-X ${EGO_PN}/config.GitCommit=${GIT_COMMIT}" \
		-mod vendor -v -work -x \
		-o git-lfs git-lfs.go
	echo "$@"
	"$@" || die

	if use doc; then
		ronn docs/man/*.ronn || die "man building failed"
	fi
}

src_install() {
	dobin git-lfs
	dodoc {CHANGELOG,CODE-OF-CONDUCT,CONTRIBUTING,README}.md
	use doc && doman docs/man/*.1
}
