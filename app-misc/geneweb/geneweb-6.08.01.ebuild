# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils

GITID=9641e494cd85fb1b7baba32412d120da38234ba2

DESCRIPTION="Genealogy software program with a Web interface"
HOMEPAGE="https://github.com/geneanet/geneweb"
SRC_URI="https://github.com/geneweb/geneweb/archive/${GITID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+ocamlopt"
RESTRICT="strip"

RDEPEND="dev-lang/ocaml[ocamlopt?]
	dev-ml/camlp5[ocamlopt?]
	acct-user/geneweb
	acct-group/geneweb"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED=(
	/usr/bin/gwb2ged
	/usr/bin/update_nldb
	/usr/bin/consang
	/usr/bin/gwd
	/usr/bin/gwsetup
	/usr/bin/ged2gwb2
	/usr/bin/gwc
	/usr/bin/ged2gwb
	/usr/bin/check_base
	/usr/bin/gwu
	/usr/bin/gwc1
	/usr/bin/gwc2
	/usr/lib/geneweb/gwtp
)

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${PN}-6.08-parallellbuild.patch )

S="${WORKDIR}"/${PN}-${GITID}

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
	dodoc ICHANGES
	emake new_distrib
	emake wrappers
	# Install doc
	cd distribution
	dodoc CHANGES.txt
	# Install binaries
	cd gw
	dobin gwc gwc1 gwc2 consang gwd gwu update_nldb ged2gwb ged2gwb2 gwb2ged gwsetup
	insinto /usr/lib/${PN}
	doins -r gwtp_tmp/*
	dodoc a.gwf
	insinto /usr/share/${PN}
	doins -r etc images lang setup gwd.arg only.txt

	cd ../..

	# Install binaries
	dobin src/check_base
	# Install manpages
	doman man/*

	# Install doc
	dodoc -r contrib
	docompress -x /usr/share/doc/${PF}/contrib

	newinitd "${FILESDIR}/geneweb.initd" geneweb
	newconfd "${FILESDIR}/geneweb.confd" geneweb
}

pkg_postinst() {
	einfo "A CGI program has been installed in /usr/lib/${PN}. Follow the"
	einfo "instructions on the README in that directory to use it"
	einfo "For 64 bits architecture you need to rebuild the database"
	einfo "\"gwu foo > foo.gw \" will save the database (use the previous"
	einfo "version to do that). \"gwc2 foo.gw -o bar \" will restore it "
	einfo "(using the current package)"
}
