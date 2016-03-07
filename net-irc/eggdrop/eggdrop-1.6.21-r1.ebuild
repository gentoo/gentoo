# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

MY_P="eggdrop${PV}"
PATCHSET_V="1.0"

DESCRIPTION="An IRC bot extensible with C or TCL"
HOMEPAGE="http://www.eggheads.org/"
SRC_URI="
	ftp://ftp.eggheads.org/pub/eggdrop/source/1.6/${MY_P}.tar.bz2
	https://dev.gentoo.org/~binki/distfiles/${CATEGORY}/${PN}/${P}-patches-${PATCHSET_V}.tar.bz2"

KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug mysql postgres ssl static vanilla"

REQUIRED_USE="vanilla? ( !mysql !postgres !ssl )"

DEPEND="
	dev-lang/tcl:0
	sys-apps/gentoo-functions
	!vanilla? (
		mysql? ( virtual/mysql )
		postgres? ( dev-db/postgresql:*[server] )
		ssl? ( dev-libs/openssl:0= )
	)"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare()  {
	# fix bug 571004 and a QA warning
	epatch "${FILESDIR}/${P}-fix-gcc5-remove-inline.patch" \
		"${FILESDIR}/${P}-fix-memset.patch"
	if use vanilla; then
		rm -f "${WORKDIR}"/patch/[1-6]*.patch || die
	fi

	EPATCH_SUFFIX="patch" epatch

	# fix bug #335230
	sed -i \
		-e '/\$(LD)/s/-o/$(CFLAGS) $(LDFLAGS) &/' \
		src/mod/*.mod/Makefile* src/Makefile.in || die
	default
}

src_configure() {
	use mysql    || ( echo mysql ; echo mystats ) >>disabled_modules
	use postgres || echo pgstats >>disabled_modules
	use static   && ( echo rijndael ; echo twofish ) >>disabled_modules

	econf $(use_with ssl)

	emake config
}

src_compile() {
	local target=""

	if use static && use debug; then
		target="sdebug"
	elif use static; then
		target="static"
	elif use debug; then
		target="debug"
	fi

	emake -j1 ${target} # fixes #533490
}

src_install() {
	local a b
	emake DEST="${D}"/opt/eggdrop install

	for a in doc/*; do
		[ -f ${a} ] && dodoc ${a}
	done

	for a in src/mod/*.mod; do
		for b in README UPDATES INSTALL TODO CONTENTS; do
			[[ -f ${a}/${b} ]] && newdoc ${a}/${b} ${b}.${a##*/}
		done
	done

	dodoc text/motd.*

	use vanilla || dodoc \
		src/mod/botnetop.mod/botnetop.conf \
		src/mod/gseen.mod/gseen.conf \
		src/mod/mc_greet.mod/mc_greet.conf \
		src/mod/stats.mod/stats.conf \
		src/mod/away.mod/away.doc \
		src/mod/rcon.mod/matchbot.tcl \
		src/mod/mystats.mod/tools/mystats.{conf,sql} \
		src/mod/pgstats.mod/tools/{pgstats.conf,setup.sql}

	dodoc -r doc/html

	dobin "${FILESDIR}"/eggdrop-installer
	doman doc/man1/eggdrop.1
}

pkg_postinst() {
	elog "Please run /usr/bin/eggdrop-installer to install your eggdrop bot."
}
