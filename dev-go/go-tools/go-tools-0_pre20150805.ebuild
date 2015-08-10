# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
EGO_PN="golang.org/x/tools/..."
EGO_SRC="golang.org/x/tools"

if [[ ${PV} = *9999* ]]; then
	inherit golang-vcs
else
	EGIT_COMMIT="d02228d1857b9f49cd0252788516ff5584266eb6"
	ARCHIVE_URI="https://github.com/golang/tools/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	inherit golang-vcs-snapshot
fi
inherit golang-build

DESCRIPTION="Go Tools"
HOMEPAGE="https://godoc.org/golang.org/x/tools"
SRC_URI="${ARCHIVE_URI}
	http://golang.org/favicon.ico -> go-favicon.ico"
LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND="dev-go/go-net:="
RDEPEND=""
RESTRICT="test"

src_prepare() {
	# Add favicon to the godoc web interface (bug 551030)
	cp "${DISTDIR}"/go-favicon.ico "src/${EGO_SRC}/godoc/static/favicon.ico" ||
		die
	sed -e 's:"example.html",:\0\n\t"favicon.ico",:' \
		-i src/${EGO_SRC}/godoc/static/makestatic.go || die
	sed -e 's:<link type="text/css":<link rel="icon" type="image/png" href="/lib/godoc/favicon.ico">\n\0:' \
		-i src/${EGO_SRC}/godoc/static/godoc.html || die
}

src_compile() {
	# Generate static.go with favicon included
	pushd src/golang.org/x/tools/godoc/static >/dev/null || die
	go run makestatic.go || die
	popd >/dev/null

	# Create a writable GOROOT in order to avoid sandbox violations.
	cp -sR "$(go env GOROOT)" "${T}/goroot" || die
	export GOROOT="${T}/goroot"
	rm -rf "${GOROOT}/src/${EGO_SRC}" || die
	rm -rf "${GOROOT}/pkg/$(go env GOOS)_$(go env GOARCH)/${EGO_SRC}" || die
	golang-build_src_compile
}

src_install() {
	local x
	golang-build_src_install
	export -n GOROOT
	exeopts -m0755 -p # preserve timestamps for bug 551486
	exeinto "$(go env GOROOT)/bin"
	doexe bin/*

	# godoc ends up in ${GOROOT}/bin
	dodir /usr/bin
	while read -r -d '' x; do
		doexe "${x}"
		ln "${ED}"usr/{lib/go/bin,bin}/${x##*/} || die
	done < <(find "${GOROOT}/bin" -type f -print0)

	exeinto "$(go env GOTOOLDIR)"
	doexe "${GOROOT}/pkg/tool/$(go env GOOS)_$(go env GOARCH)/cover"
	doexe "${GOROOT}/pkg/tool/$(go env GOOS)_$(go env GOARCH)/vet"
}
