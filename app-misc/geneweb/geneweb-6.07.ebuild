# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils user

MY_PN=gw
MY_PV=${PV/./-}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Genealogy software program with a Web interface"
HOMEPAGE="http://opensource.geneanet.org/projects/geneweb"
SRC_URI="http://opensource.geneanet.org/attachments/download/240/${MY_P}-src.tgz
	mirror://gentoo/${P}-reduce-utf8.ml.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+ocamlopt"

RDEPEND="dev-lang/ocaml[ocamlopt?]
	dev-ml/camlp5[ocamlopt?]"
DEPEND="${RDEPEND}
	!net-p2p/ghostwhitecrab"

S=${WORKDIR}/gw-${PV}-src

src_prepare() {
	esvn_clean
	epatch "${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-parallellbuild.patch \
		../${P}-reduce-utf8.ml.patch
}

src_compile() {
	if use ocamlopt; then
		emake
	else
		emake OCAMLC=ocamlc OCAMLOPT=ocamlopt out
		# If using bytecode we dont want to strip the binary as it would remove
		# the bytecode and only leave ocamlrun...
		export STRIP_MASK="*/bin/*"
	fi
}

src_install() {
	dodoc ICHANGES
	emake distrib
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
	insinto /usr/share/doc/${PF}/contrib
	doins -r contrib/{gwdiff,misc}

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
	einfo "(usiing the current package)"
}
