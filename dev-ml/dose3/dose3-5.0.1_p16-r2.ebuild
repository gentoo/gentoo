# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library to perform analysis on package repositories"
HOMEPAGE="http://www.mancoosi.org/software/ https://gforge.inria.fr/projects/dose"
SRC_URI="http://deb.debian.org/debian/pool/main/d/dose3/${PN}_$(ver_cut 1-3).orig.tar.gz"
SRC_URI+=" http://deb.debian.org/debian/pool/main/d/dose3/${PN}_${PV/_p/-}.debian.tar.xz"
#SRC_URI="https://gforge.inria.fr/frs/download.php/file/36063/${P}.tar.gz"
S="${WORKDIR}/${PN}-$(ver_cut 1-3)"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
IUSE="+ocamlopt parmap zip bzip2 xml curl rpm4 test"

BDEPEND="
	dev-ml/cppo
	dev-ml/findlib
	dev-ml/ocamlbuild
"
RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt=]
	<=dev-lang/ocaml-4.09.0:=[ocamlopt=]
	dev-ml/cudf:=[ocamlopt=]
	>=dev-ml/extlib-1.7.0:=[ocamlopt=]
	>=dev-ml/ocamlgraph-1.8.6:=[ocamlopt=]
	<dev-ml/ocamlgraph-1.8.9:=[ocamlopt=]
	>=dev-ml/re-1.9.0:=[ocamlopt=]
	parmap? ( dev-ml/parmap:=[ocamlopt=] )
	zip? ( dev-ml/camlzip:=[ocamlopt=] )
	bzip2? ( dev-ml/camlbz2:= )
	xml? (
		dev-ml/ocaml-expat:=[ocamlopt=]
		dev-ml/xml-light:=[ocamlopt=]
	)
	curl? ( dev-ml/ocurl:= )
	rpm4? ( app-arch/rpm )
"
DEPEND="${RDEPEND}
	test? ( dev-python/pyyaml[libyaml] )
"

# missing test data
RESTRICT="test"

QA_FLAGS_IGNORED='.*'

src_prepare() {
	default
	sed -e 's/INSTALLOPTS=-s/INSTALLOPTS=/' -i Makefile.config.in || die

	# Not relevant to us, Debian specific adjustments
	rm "${WORKDIR}"/debian/patches/0009-Fix-and-constraints-against-virtual-packages.patch || die
	rm "${WORKDIR}"/debian/patches/binaries-prefix-edos || die

	elog "Applying Debian patchset..."
	for file in "${WORKDIR}"/debian/patches/*.patch ; do
		eapply "${file}"
	done
}

src_configure() {
	econf \
		$(use ocamlopt || echo "--with-bytecodeonly") \
		$(use parmap && echo "--with-parmap") \
		$(use zip && echo "--with-zip") \
		$(use bzip2 && echo "--with-bz2") \
		$(use xml && echo "--with-xml") \
		$(use curl && echo "--with-curl") \
		$(use rpm4 && echo "--with-rpm4")
}

src_compile() {
	emake -j1 VERBOSE="-classic-display"
}

src_install() {
	emake DESTDIR="${D}" BINDIR="${ED}/usr/bin" install || die
	dodoc CHANGES CREDITS README.architecture TODO
}
