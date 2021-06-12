# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

DESCRIPTION="Command line interface to JMESPath"
HOMEPAGE="https://github.com/jmespath/jp http://jmespath.org"
SRC_URI="https://github.com/jmespath/jp/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT+=" test"

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
	go build -mod=readonly -o ./jp ./jp.go || die
}

src_install() {
	dobin "./jp"
	dodoc README.md
}
