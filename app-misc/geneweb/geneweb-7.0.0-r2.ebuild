# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils

DESCRIPTION="Genealogy software program with a Web interface"
HOMEPAGE="https://github.com/geneweb/geneweb"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt test"
RESTRICT="strip !test? ( test )"

RDEPEND="dev-lang/ocaml[ocamlopt?]
	<dev-ml/camlp5-8:=[ocamlopt?]
	acct-user/geneweb
	acct-group/geneweb
	dev-ml/jingoo:=
	dev-ml/uunf:=
	>=dev-ml/markup-1.0.0:=
	dev-ml/unidecode:=
	dev-ml/calendars:="
DEPEND="${RDEPEND}
	dev-ml/cppo
	test? ( dev-ml/ounit2 )"

QA_FLAGS_IGNORED='.*'

src_prepare() {
	default

	sed -i -e "s/oUnit/ounit2/" test/dune.in || die
}

src_configure() {
	ocaml ./configure.ml
}

src_compile() {
	if use ocamlopt; then
		emake
	else
		emake OCAMLC=ocamlc OCAMLOPT=ocamlopt out
		# If using bytecode we dont want to strip the binary as it would remove
		# the bytecode and only leave ocamlrun...
	fi
}

src_install() {
	default
	mv "${D}"/usr/bin/{,gw}setup || die
	rm -r "${D}"/usr/doc || die
	dodoc ICHANGES etc/README.txt etc/a.gwf

	# Install manpages
	doman man/*

	emake distrib
	cd distribution/gw
	insinto /usr/share/${PN}
	doins -r etc images lang setup gwd.arg only.txt

	newinitd "${FILESDIR}/geneweb.initd" geneweb
	newconfd "${FILESDIR}/geneweb.confd" geneweb
}

pkg_postinst() {
	einfo "A CGI program has been installed in /usr/lib/${PN}. Follow the"
	einfo "instructions on the README in that directory to use it"
	einfo "If you come from an old version you need to rebuild the database"
	einfo "\"gwu foo > foo.gw \" will save the database (use the previous"
	einfo "version to do that). \"gwc2 foo.gw -o bar \" will restore it "
	einfo "(using the current package)"
}
