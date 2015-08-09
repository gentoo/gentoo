# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic prefix toolchain-funcs

DESCRIPTION="Development toolkit and applications for computational biology, including NCBI BLAST"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/"
SRC_URI="ftp://ftp.ncbi.nlm.nih.gov/blast/executables/release/${PV}/ncbi.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~alpha amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc static-libs X"

RDEPEND="
	app-shells/tcsh
	dev-lang/perl
	media-libs/libpng:0=
	X? (
		media-libs/fontconfig
		x11-libs/motif:0=
		x11-libs/libICE
		x11-libs/libX11
		x11-libs/libXft
		x11-libs/libXmu
		x11-libs/libXt
		)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/ncbi"

EXTRA_VIB="asn2all asn2asn"

pkg_setup() {
	echo
	ewarn 'Please note that the NCBI toolkit (and especially the X'
	ewarn 'applications) are known to have compilation and run-time'
	ewarn 'problems when compiled with agressive compilation flags. The'
	ewarn '"-O3" flag is filtered by the ebuild on the x86 architecture if'
	ewarn 'X support is enabled.'
	echo
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-extra_vib.patch \
		"${FILESDIR}"/${P}-bfr-overflow.patch \
		"${FILESDIR}"/${P}-format-security.patch \
		"${FILESDIR}"/${P}-_DEFAULT_SOURCE.patch

	if use ppc || use ppc64; then
		epatch "${FILESDIR}"/${PN}-lop.patch
	fi

	if ! use X; then
		sed \
			-e "s:\#set HAVE_OGL=0:set HAVE_OGL=0:" \
			-e "s:\#set HAVE_MOTIF=0:set HAVE_MOTIF=0:" \
			-i "${S}"/make/makedis.csh || die
	else
		# X applications segfault on startup on x86 with -O3.
		use x86 || replace-flags '-O3' '-O2'
	fi

	# Apply user C flags...
	cd "${S}"/platform
	sed \
		-e "s:-O[s0-9]\?::g" \
		-e 's:-m\(cpu\|arch\)=[a-zA-Z0-9]*::g' \
		-e 's:-x[A-Z]*::g' \
		-e 's:-pipe::g' \
		-e "/NCBI_MAKE_SHELL *=/s:=.*:= \"${EPREFIX}/bin/sh\":g" \
		-e "/NCBI_AR *=/s:ar:$(tc-getAR):g" \
		-e "/NCBI_RANLIB *=/s:ranlib:$(tc-getRANLIB):g" \
		-e "/NCBI_CC *=/s:= [a-zA-Z0-9]* := $(tc-getCC) :g" \
		-e "/NCBI_OPTFLAG *=/s:$: ${CFLAGS}:g" \
		-e "/NCBI_LDFLAGS1 *=/s:$: ${CFLAGS} ${LDFLAGS}:g" \
		-e "/NCBI_OGLLIBS *=/s:=.*:= $($(tc-getPKG_CONFIG) --cflags gl glu 2>/dev/null):g" \
		-e "/OPENGL_LIBS *=/s:=.*:= $($(tc-getPKG_CONFIG) --libs gl glu 2>/dev/null):g" \
		-e "/NCBI_OGLLIBS *=/s:=.*:= $($(tc-getPKG_CONFIG) --libs gl glu 2>/dev/null):g" \
		-i * || die

	# We use dynamic libraries
	sed -i -e "s/-Wl,-Bstatic//" *linux*.ncbi.mk || die

	sed \
		-re "s:/usr(/bin/.*sh):\1:g" \
		-e "s:(/bin/.*sh):${EPREFIX}\1:g" \
		-i $(find "${S}" -type f) || die
}

src_compile() {
	export EXTRA_VIB
	cd "${WORKDIR}"
	csh ncbi/make/makedis.csh || die
	mkdir "${S}"/cgi "${S}"/real || die
	mv "${S}"/bin/*.cgi "${S}"/cgi || die
	mv "${S}"/bin/*.REAL "${S}"/real || die
	cd "${S}"/demo
	emake \
		-f ../make/makenet.unx \
		CC="$(tc-getCC) ${CFLAGS} -I../include  -L../lib" \
		LDFLAGS="${LDFLAGS}" \
		spidey
	cp spidey ../bin/ || die
}

src_install() {
	#sci-geosciences/cdat-lite
	mv "${S}"/bin/cdscan "${S}"/bin/cdscan-ncbi || die

	dobin "${S}"/bin/*

	for i in ${EXTRA_VIB}; do
		dobin "${S}"/build/${i} || die "Failed to install binaries."
	done
	use static-libs && dolib.a "${S}"/lib/*.a
	mkdir -p "${ED}"/usr/include/ncbi
	cp -RL "${S}"/include/* "${ED}"/usr/include/ncbi || \
		die "Failed to install headers."

	# TODO: wwwblast with webapps
	#insinto /usr/share/ncbi/lib/cgi
	#doins ${S}/cgi/*
	#insinto /usr/share/ncbi/lib/real
	#doins ${S}/real/*

	# Basic documentation
	dodoc "${S}"/{README,VERSION,doc/{*.txt,README.*}}
	newdoc "${S}"/doc/fa2htgs/README README.fa2htgs
	newdoc "${S}"/config/README README.config
	newdoc "${S}"/network/encrypt/README README.encrypt
	newdoc "${S}"/network/nsclilib/readme README.nsclilib
	newdoc "${S}"/sequin/README README.sequin
	mv "${S}"/doc/man/fmerge{,-ncbi}.1 || die
	doman "${S}"/doc/man/*

	# Hypertext user documentation
	dohtml "${S}"/{README.htm,doc/{*.html,*.htm,*.gif}}
	insinto /usr/share/doc/${PF}/html
	doins -r "${S}"/doc/blast "${S}"/doc/images "${S}"/doc/seq_install

	# Developer documentation
	if use doc; then
		# Demo programs
		mkdir "${ED}"/usr/share/ncbi
		mv "${S}"/demo "${ED}"/usr/share/ncbi/demo || die
	fi

	# Shared data (similarity matrices and such) and database directory.
	insinto /usr/share/ncbi
	doins -r "${S}"/data
	dodir /usr/share/ncbi/formatdb

	# Default config file to set the path for shared data.
	insinto /etc/ncbi
	newins "${FILESDIR}"/ncbirc .ncbirc
	eprefixify "${ED}"/etc/ncbi/.ncbirc

	# Env file to set the location of the config file and BLAST databases.
	newenvd "${FILESDIR}"/21ncbi-r1 21ncbi
}
