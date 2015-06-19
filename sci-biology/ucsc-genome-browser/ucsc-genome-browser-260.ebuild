# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/ucsc-genome-browser/ucsc-genome-browser-260.ebuild,v 1.2 2015/04/17 06:21:51 jlec Exp $

EAPI=5

inherit toolchain-funcs flag-o-matic webapp

DESCRIPTION="The UCSC genome browser suite, also known as Jim Kent's library and GoldenPath"
HOMEPAGE="http://genome.ucsc.edu/"
SRC_URI="http://hgdownload.cse.ucsc.edu/admin/jksrc.v${PV}.zip"

LICENSE="blat"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mysql +server static-libs"

REQUIRED_USE="server? ( mysql )"

WEBAPP_MANUAL_SLOT="yes"

DEPEND="
	app-arch/unzip
	!<sci-biology/ucsc-genome-browser-223
	mysql? ( virtual/mysql )
	server? ( virtual/httpd-cgi )" # TODO: test with other webservers
RDEPEND="${DEPEND}"

S="${WORKDIR}/kent"

src_prepare() {
	use server && webapp_src_preinst
	sed \
		-e 's/-Werror//' \
		-e "/COPT/s:=.*$:=${LDFLAGS}:g" \
		-e "s/CC=gcc/CC=$(tc-getCC) ${CFLAGS}/" \
		-e 's:${CC} ${COPT} ${CFLAGS}:${CC} ${CFLAGS}:g' \
		-i src/inc/common.mk src/hg/lib/makefile || die
	find -name makefile -or -name cgi_build_rules.mk \
		| xargs sed -i \
			-e 's/-${USER}//g' \
			-e 's/-$(USER)//g' \
			-e 's:-O2::g' \
			-e 's:-ggdb::g' \
			-e 's:-pipe::g' || die
	sed \
		-e 's:${DISTDIR}${BINDIR}:${BINDIR}:g' \
		-i src/hg/genePredToMafFrames/makefile || die
}

src_compile() {
	export MACHTYPE=${MACHTYPE/-*/} \
		BINDIR="${WORKDIR}/destdir/opt/${PN}/bin" \
		SCRIPTS="${WORKDIR}/destdir/opt/${PN}/cluster/scripts" \
		ENCODE_PIPELINE_BIN="${WORKDIR}/destdir/opt/${PN}/cluster/data/encode/pipeline/bin" \
		PATH="${BINDIR}:${PATH}" \
		STRIP="echo 'skipping strip' "

	export MYSQLLIBS="none" MYSQLINC="none" DOCUMENTROOT="none" CGI_BIN="none"

	use mysql && export MYSQLLIBS="-L${EROOT}usr/$(get_libdir)/mysql/ -lmysqlclient -lz -lssl" \
		MYSQLINC="${ROOT}usr/include/mysql"

	use server && export DOCUMENTROOT="${WORKDIR}/destdir/${MY_HTDOCSDIR}" \
		CGI_BIN="${WORKDIR}/destdir/${MY_HTDOCSDIR}/cgi-bin"

	mkdir -p "$BINDIR" "$SCRIPTS" "$ENCODE_PIPELINE_BIN" || die
	use server && mkdir -p "$CGI_BIN" "$DOCUMENTROOT"

	emake -C src clean
	emake -C src/lib
	emake -C src/jkOwnLib
	emake -C src/utils/stringify
	emake -C src blatSuite
	if use mysql; then
		emake -j1 -C src/hg utils
		emake -j1 -C src utils
		emake -C src libs userApps
		if use server; then
			emake -j1 -C src/hg
			emake -j1 -C src
		fi
	fi
}

src_install() {
	use server && webapp_src_preinst
	cp -ad "${WORKDIR}"/destdir/* "${D}" || die
	use static-libs && dolib.a src/lib/${MACHTYPE/-*/}/*.a
	echo "PATH=${EPREFIX}/opt/${PN}/bin" > "${S}/98${PN}"
	doenvd "${S}/98${PN}"

	use server && webapp_postinst_txt en src/product/README.QuickStart
	use server && webapp_src_install

	insinto "/usr/include/${PN}"
	doins src/inc/*.h
	insinto "/usr/share/${PN}"
	doins -r src/product
	keepdir "/usr/share/doc/${PF}"
	find -name 'README*' -or -name '*.doc' | grep -v test | cpio -padv "${ED}/usr/share/doc/${PF}" || die
}

pkg_postinst() {
	use server && webapp_pkg_postinst
}
