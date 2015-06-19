# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/smlnj/smlnj-110.75.ebuild,v 1.5 2013/08/15 05:29:12 patrick Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="Standard ML of New Jersey compiler and libraries"
HOMEPAGE="http://www.smlnj.org"

BASE_URI="http://smlnj.cs.uchicago.edu/dist/working/${PV}"

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
SRC_URI="amd64? ( ${BASE_URI}/boot.x86-unix.tgz -> ${P}-boot.x86-unix.tgz )
		 ppc?   ( ${BASE_URI}/boot.ppc-unix.tgz -> ${P}-boot.ppc-unix.tgz )
		 sparc? ( ${BASE_URI}/boot.sparc-unix.tgz -> ${P}-boot.sparc-unix.tgz )
		 x86?   ( ${BASE_URI}/boot.x86-unix.tgz -> ${P}-boot.x86-unix.tgz )"

for file in ${FILES}; do
	SRC_URI+=" ${BASE_URI}/${file} -> ${P}-${file} "
done

LICENSE="BSD"
SLOT="0"

#sparc support should be there but is untested
KEYWORDS="-* ~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	mkdir -p "${S}"
	for file in ${A}; do
		[[ ${file} != ${P}-config.tgz ]] && cp "${DISTDIR}/${file}" "${S}/${file#${P}-}"
	done

#	make sure we don't use the internet to download anything
	unpack ${P}-config.tgz && rm config/*.bat
	echo SRCARCHIVEURL=\"file:/${S}\" > "${S}"/config/srcarchiveurl
}

DIR=/usr

src_prepare() {
	# respect CC et al. (bug 243886)
	mkdir base || die # without this unpacking runtime will fail
	./config/unpack "${S}" runtime || die
	for file in mk.*; do
		sed -e "/^AS/s:as:$(tc-getAS):" \
			-e "/^CC/s:gcc:$(tc-getCC):" \
			-e "/^CPP/s:gcc:$(tc-getCC):" \
			-e "/^CFLAGS/{s:-O[0123s]:: ; s:=:= ${CFLAGS}:}" \
			-i base/runtime/objs/${file}
	done

#	# stash bin and lib somewhere (bug 248162)
#	sed -e "/@BINDIR@/s:\$BINDIR:${DIR}:" \
#		-e "/@LIBDIR@/s:\$LIBDIR:${DIR}/lib:" \
#		-i config/install.sh || die
}

src_compile() {
	SMLNJ_HOME="${S}" ./config/install.sh || die "compilation failed"
}

src_install() {
	mkdir -p "${D}"/${DIR} || die
	mv bin lib "${D}"/${DIR} || die

#	for file in "${D}"/${DIR}/bin/*; do
#		dosym /${DIR}/bin/$(basename "${file}") /usr/bin/$(basename "${file}") || die
#	done

#	for file in $(find "${D}"/usr/lib/${PN}/bin/ -maxdepth 1 -type f ! -name ".*"); do
#		dosym /${DIR}/bin/$(basename "${file}") /usr/bin/$(basename "${file}") || die
#	done

	for file in "${D}"/usr/bin/{*,.*}; do
		[[ -f ${file} ]] && sed "2iSMLNJ_HOME=/usr" -i ${file}
#		[[ -f ${file} ]] && sed "s:${WORKDIR}:/usr:" -i ${file}
	done
}
