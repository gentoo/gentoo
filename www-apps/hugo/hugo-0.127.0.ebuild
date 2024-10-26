# Copyright 2018-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion

DESCRIPTION="Fast static HTML and CSS website generator"
HOMEPAGE="https://gohugo.io https://github.com/gohugoio/hugo"
SRC_URI="
	https://github.com/gohugoio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://tastytea.de/files/gentoo/${P}-vendor.tar.xz
"

# NOTE: To create the vendor tarball, run:
# `go mod vendor && cd .. && tar -caf ${P}-vendor.tar.xz ${P}/vendor`

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~riscv ~x86"
IUSE="doc +extended test"

BDEPEND="
	>=dev-lang/go-1.22.2
	test? (
		dev-python/docutils
		dev-ruby/asciidoctor
		virtual/pandoc
	)
"
RDEPEND="
	extended? (
		dev-libs/libsass:=
		>=media-libs/libwebp-1.3.2:=
	)
"
DEPEND="${RDEPEND}"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.121.0-unbundle-libwebp-and-libsass.patch
	"${FILESDIR}"/${PN}-0.123.0-skip-some-tests.patch
)

src_configure() {
	export CGO_ENABLED=1
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"
	export MY_BUILD_FLAGS="$(usev extended "-tags extended")"

	default
}

src_prepare() {
	# wants to run command that require network access
	rm testscripts/commands/mod{,_vendor,__disable,_get,_get_u,_npm{,_withexisting}}.txt || die

	default
}

src_compile() {
	mkdir -pv bin || die
	ego build -ldflags "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=gentoo:${PVR}" \
		${MY_BUILD_FLAGS} -o "${S}/bin/hugo"

	bin/hugo gen man --dir man || die

	mkdir -pv completions || die
	bin/hugo completion bash > completions/hugo || die
	bin/hugo completion fish > completions/hugo.fish || die
	bin/hugo completion zsh > completions/_hugo || die

	if use doc ; then
		bin/hugo gen doc --dir doc || die
	fi
}

src_test() {
	ego test "./..." ${MY_BUILD_FLAGS}
}

src_install() {
	dobin bin/*
	doman man/*

	dobashcomp completions/${PN}
	dofishcomp completions/${PN}.fish
	dozshcomp completions/_${PN}

	if use doc ; then
		dodoc -r doc/*
	fi
}

pkg_postinst() {
	elog "the sass USE-flag was renamed to extended. the functionality is the" \
		"same, except it also toggles the dependency on libwebp (for encoding)"
}
