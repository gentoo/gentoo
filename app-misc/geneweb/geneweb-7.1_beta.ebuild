# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dune
MYPV=${PV/_/-}

DESCRIPTION="Genealogy software program with a Web interface"
HOMEPAGE="https://github.com/geneweb/geneweb"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${MYPV}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${MYPV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="strip
	!test? ( test )"

DEPEND="
	acct-group/geneweb
	acct-user/geneweb
	dev-ml/calendars:=[ocamlopt?]
	>=dev-ml/camlp5-8.03.00:=[ocamlopt?]
	dev-ml/camlp-streams:=[ocamlopt?]
	dev-ml/jingoo:=[ocamlopt?]
	dev-ml/markup:=[ocamlopt?]
	dev-ml/num:=[ocamlopt?]
	dev-ml/ppx_deriving:=[ocamlopt?]
	dev-ml/ppx_import:=[ocamlopt?]
	dev-ml/re:=[ocamlopt?]
	dev-ml/stdlib-shims:=[ocamlopt?]
	dev-ml/unidecode:=[ocamlopt?]
	dev-ml/uri:=[ocamlopt?]
	dev-ml/uucp:=
	dev-ml/uunf:=
	dev-ml/uutf:=[ocamlopt?]
	dev-ml/zarith:=[ocamlopt?]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-ml/cppo
	>=dev-ml/dune-2.9
	dev-ml/findlib
	test? ( dev-ml/alcotest )"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.1_alpha2-nogwrepl.patch
	"${FILESDIR}"/${PN}-7.0.1_alpha2-camlp5.patch
	"${FILESDIR}"/${P}-test.patch
)

src_configure() {
	ocaml ./configure.ml --sosa-zarith || die
}

src_compile() {
	emake -j1 distrib
}

src_install() {
	dune_src_install
	rm "${D}"/usr/share/doc/${PF}/geneweb/LICENSE || die
	mv "${D}"/usr/share/doc/${PF}/geneweb/* "${D}"/usr/share/doc/${PF}/ || die

	dodoc ICHANGES etc/README.txt etc/a.gwf

	# Install manpages
	doman man/*

	cd distribution/gw
	insinto /usr/share/${PN}
	doins -r etc images lang setup gwd.arg

	keepdir /var/lib/${PN}

	newinitd "${FILESDIR}/geneweb.initd-r2" geneweb
	newconfd "${FILESDIR}/geneweb.confd" geneweb
}

pkg_postinst() {
	einfo "If you come from an old version you need to rebuild the database"
	einfo "\"geneweb.gwu foo -o foo.gw \" will save the database (use the previous"
	einfo "version to do that). \"geneweb.gwc foo.gw -o bar \" will restore it "
	einfo "(using the current package)"
}
