# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Routines to generate / analyze graphs using models for internetwork topology"
HOMEPAGE="http://www.cc.gatech.edu/fac/Ellen.Zegura/graphs.html
		http://www.isi.edu/nsnam/ns/ns-topogen.html#gt-itm"
SRC_URI="http://www.cc.gatech.edu/fac/Ellen.Zegura/gt-itm/gt-itm.tar.gz -> ${P}.tar.gz
		http://www.isi.edu/nsnam/dist/sgb2ns.tar.gz -> sgb2ns-${PV}.tar.gz"
S="${WORKDIR}/${PN}"
S2="${WORKDIR}/sgb2ns"

LICENSE="all-rights-reserved sgb2ns"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist"
IUSE="doc"

DEPEND="dev-util/sgb"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-19961004-gentoo.patch
	"${FILESDIR}"/${PN}-implicits.patch
	"${FILESDIR}"/${PN}-19961004-Fix-build-with-Clang-16.patch
	"${FILESDIR}"/${PN}-19961004-Fix-musl-build.patch
)

DOCS=( README docs/. )

src_unpack() {
	unpack "sgb2ns-${PV}.tar.gz"

	mkdir "${S}" || die
	cd "${S}" || die
	unpack "${P}.tar.gz"
}

src_prepare() {
	rm -f lib/* || die

	cd "${WORKDIR}" || die
	default
	cd "${S}" || die
}

src_compile() {
	append-cflags -std=gnu89

	emake -C src CFLAGS="${CFLAGS} -I../include" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"

	emake -C "${S2}" CFLAGS="${CFLAGS} -I\$(IDIR) -L\$(LDIR)" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"
}

src_install() {
	dobin bin/*

	einstalldocs
	newdoc "${S2}"/README README.sgb2ns

	if use doc; then
		dodoc -r sample-graphs
		dodoc "${S2}"/*.{tcl,gb}
		docompress -x /usr/share/doc/${PF}/sample-graphs
	fi
}
