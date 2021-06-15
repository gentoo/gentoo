# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

MY_PN=jpp
MY_P=${MY_PN}-${PV}

DESCRIPTION="Command line interface to JMESPath"
HOMEPAGE="https://github.com/pipebus/jpp https://github.com/jmespath/jp/pull/30 http://jmespath.org"
SRC_URI="https://github.com/pipebus/jpp/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+jp +jpp"
RESTRICT+=" test"
REQUIRED_USE="|| ( jp jpp )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if [[ -e $S/go.mod ]]; then
		die "found unexpected $S/go.mod"
	fi
	cat <<-EOF > "$S/go.mod"
	module github.com/jmespath/jp
	replace github.com/jmespath/jp => ./
	EOF

	sed -e 's|except Exception, e|except Exception as e|' -i test/jp-compliance || die

	default
}

src_compile() {
	if use jp; then
		go build -mod=readonly -o ./jp ./jp.go || die
	fi
	if use jpp; then
		go build -mod=readonly -o ./jpp ./cmd/jpp/main.go || die
	fi
}

src_install() {
	use jp && dobin "./jp"
	use jpp && dobin "./jpp"
	dodoc README.md
}
