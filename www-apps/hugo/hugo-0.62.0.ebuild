# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module bash-completion-r1

# The fork with prefetched vendor packages using `go mod vendor`
EGO_PN="github.com/g4s8/hugo"
GIT_COMMIT="6608f1557054a7d0230dff260c1b66bc19e65ec8"
KEYWORDS="~amd64"

DESCRIPTION="The world's fastest framework for building websites"
HOMEPAGE="https://gohugo.io https://github.com/gohugoio/hugo"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 Unlicense BSD BSD-2 MPL-2.0"
SLOT="0"
IUSE="+sass +bash-completion doc"

RESTRICT="test"

src_compile() {
	mkdir -pv bin || die
	go build -ldflags \
		"-X ${EGO_PN}/hugolib.CommitHash=${GIT_COMMIT}" \
		$(usex sass "-tags extended" "") -o "${S}/bin/hugo" || die
	bin/hugo gen man --dir man || die
	if use bash-completion ; then
		bin/hugo gen autocomplete --completionfile hugo || die
	fi
	if use doc ; then
		bin/hugo gen doc --dir doc || die
	fi
}

src_install() {
	dobin bin/*
	doman man/*
	if use bash-completion ; then
		dobashcomp hugo || die
	fi
	if use doc ; then
		dodoc -r doc/
	fi
}
