# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/smlnj/smlnj-110.71.ebuild,v 1.2 2010/06/29 12:13:03 ssuominen Exp $

EAPI=2

inherit eutils

DESCRIPTION="Standard ML of New Jersey compiler and libraries"
HOMEPAGE="http://www.smlnj.org"

BASE_URI="http://smlnj.cs.uchicago.edu/dist/working/${PV}/"
#BASE_URI="mirror://gentoo/${P}-"

#Use the fetch_files.sh script in subdir files/ to fetch and
#version these files if they aren't on Gentoo mirrors.
#For example if you're doing a local bump.
FILES="
config.tgz

cm.tgz
compiler.tgz
runtime.tgz
system.tgz
MLRISC.tgz
smlnj-lib.tgz

ckit.tgz
nlffi.tgz

cml.tgz
eXene.tgz

ml-lex.tgz
ml-yacc.tgz
ml-burg.tgz
ml-lpt.tgz

pgraph.tgz
trace-debug-profile.tgz

heap2asm.tgz

smlnj-c.tgz
"

#use amd64 in 32-bit mode
SRC_URI="amd64? ( ${BASE_URI}boot.x86-unix.tgz -> ${P}-boot.x86-unix.tgz )
		 ppc?   ( ${BASE_URI}boot.ppc-unix.tgz -> ${P}-boot.ppc-unix.tgz )
		 sparc? ( ${BASE_URI}boot.sparc-unix.tgz -> ${P}-boot.sparc-unix.tgz )
		 x86?   ( ${BASE_URI}boot.x86-unix.tgz -> ${P}-boot.x86-unix.tgz )"

for file in ${FILES}; do
	SRC_URI+=" ${BASE_URI}${file} -> ${P}-${file} "
done

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	mkdir -p "${S}"
	for file in ${A}; do
		[[ ${file} != ${P}-config.tgz ]] && cp "${DISTDIR}/${file}" "${S}/${file#${P}-}"
	done
	unpack ${P}-config.tgz && rm config/*.bat
	echo SRCARCHIVEURL=\"file:/${S}\" > "${S}"/config/srcarchiveurl

	# Required for sed in src_prepare
	mkdir base || die
	./config/unpack "${S}" runtime || die
}

src_prepare() {
	# Use environment wrt #243886
	sed -i \
		-e "/^AS/s:as:$(tc-getAS):" \
		-e "/^CC/s:gcc:$(tc-getCC):" \
		-e "/^CPP/s:gcc:$(tc-getCC):" \
		-e "/^CFLAGS/{s:-O[0123s]:: ; s:=:= ${CFLAGS}:}" \
		base/runtime/objs/mk.x86-linux || die
}

src_compile() {
	SMLNJ_HOME="${S}" ./config/install.sh || die "compilation failed"
}

src_install() {
	mkdir -p "${D}"/usr
	mv {bin,lib} "${D}"/usr

	for file in "${D}"/usr/bin/{*,.*}; do
		[[ -f ${file} ]] && sed "2iSMLNJ_HOME=/usr" -i ${file}
#		[[ -f ${file} ]] && sed "s:${WORKDIR}:/usr:" -i ${file}
	done
}
