# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module bash-completion-r1

DESCRIPTION="Fast static HTML and CSS website generator"
HOMEPAGE="https://gohugo.io https://github.com/gohugoio/hugo"
SRC_URI="
	https://github.com/gohugoio/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://tastytea.de/files/${P}-vendor.tar.xz
"

# NOTE: To create the vendor tarball, run:
# `go mod vendor && cd .. && tar -cJf ${P}-vendor.tar.xz ${P}/vendor`

LICENSE="Apache-2.0 BSD BSD-2 MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +sass"

BDEPEND=">=dev-lang/go-1.18"
RDEPEND="
	media-libs/libwebp
	sass? ( dev-libs/libsass )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.92.2-link-to-webp-and-sass.patch" )

src_configure() {
	export CGO_ENABLED=1
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS} -DLIBWEBP_NO_SRC -DUSE_LIBSASS_SRC"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"

	default
}

src_compile() {
	mkdir -pv bin || die
	local my_import_path="github.com/gohugoio/hugo/common"
	local mybuildtags="-tags $(usev sass "extended,")nodeploy"
	ego build -ldflags \
		"-X ${my_import_path}/hugo.buildDate=$(date --iso-8601=seconds) -X ${my_import_path}/hugo.vendorInfo=Gentoo" \
		${mybuildtags} -o "${S}/bin/hugo"

	bin/hugo gen man --dir man || die

	mkdir -pv completions || die
	bin/hugo completion bash > completions/hugo || die
	bin/hugo completion fish > completions/hugo.fish || die
	bin/hugo completion zsh > completions/_hugo || die

	if use doc ; then
		bin/hugo gen doc --dir doc || die
	fi
}

src_install() {
	dobin bin/*
	doman man/*

	dobashcomp completions/${PN}

	insinto /usr/share/fish/vendor_completions.d
	doins completions/${PN}.fish

	insinto /usr/share/zsh/site-functions
	doins completions/_${PN}

	if use doc ; then
		dodoc -r doc/*
	fi
}
