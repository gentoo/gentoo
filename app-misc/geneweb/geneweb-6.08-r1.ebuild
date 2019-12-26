# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils user

DESCRIPTION="Genealogy software program with a Web interface"
HOMEPAGE="https://github.com/geneanet/geneweb"
SRC_URI="https://github.com/geneweb/geneweb/archive/v6.08.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~tupone/${P}-ocaml-4.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+ocamlopt"
RESTRICT="strip"

RDEPEND="dev-lang/ocaml[ocamlopt?]
	dev-ml/camlp5[ocamlopt?]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${WORKDIR}"/${P}-ocaml-4.patch
	"${FILESDIR}"/${PF}-gentoo.patch
	"${FILESDIR}"/${P}-parallellbuild.patch )

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
	enewuser geneweb "" "/bin/bash" /var/lib/geneweb
	einfo "A CGI program has been installed in /usr/lib/${PN}. Follow the"
	einfo "instructions on the README in that directory to use it"
	einfo "For 64 bits architecture you need to rebuild the database"
	einfo "\"gwu foo > foo.gw \" will save the database (use the previous"
	einfo "version to do that). \"gwc2 foo.gw -o bar \" will restore it "
	einfo "(using the current package)"
}
