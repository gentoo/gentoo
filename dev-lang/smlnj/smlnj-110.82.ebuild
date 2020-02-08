# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Standard ML of New Jersey compiler and libraries"
HOMEPAGE="http://www.smlnj.org"

BASE_URI="http://smlnj.cs.uchicago.edu/dist/working/${PV}"

FILES="
doc.tgz

config.tgz

cm.tgz
compiler.tgz
runtime.tgz
system.tgz
MLRISC.tgz
smlnj-lib.tgz
old-basis.tgz

ckit.tgz
nlffi.tgz

cml.tgz
eXene.tgz

ml-lpt.tgz
ml-lex.tgz
ml-yacc.tgz
ml-burg.tgz

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
IUSE="pax_kernel"
DEPEND="pax_kernel? ( sys-apps/elfix )"
RDEPEND=""

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

src_prepare() {
	# respect CC et al. (bug 243886)
	mkdir base || die # without this unpacking runtime will fail
	./config/unpack "${S}" runtime || die
	epatch "${FILESDIR}/${PN}-110.82-pax-p1.patch"
	epatch "${FILESDIR}/${PN}-110.82-pax-p2.patch"
	epatch "${FILESDIR}/${PN}-110.82-pax-p3.patch"
	default
	for file in mk.*; do
		sed -e "/^AS/s:as:$(tc-getAS):" \
			-e "/^CC/s:gcc:$(tc-getCC):" \
			-e "/^CPP/s:gcc:$(tc-getCC):" \
			-e "/^CFLAGS/{s:-O[0123s]:: ; s:=:= ${CFLAGS}:}" \
			-e "/^PAXMARK/s:true:"$(usex pax_kernel "paxmark.sh" "true")":" \
			-i base/runtime/objs/${file}
	done
}

src_compile() {
	SMLNJ_HOME="${S}" \
		./config/install.sh || die "compilation failed"
}

# Return an array which has the element $1 removed from the array $[@]:1
# i.e. return an array where the first function argument $1 removed from
# the array consisting of the rest of the function arguments.
remove_element_from_array() {
	local args=("$@")
	local e=${args[0]}
	local oa=()
	for x in "${args[@]:1}"; do
		if [ ${x} != ${e} ]; then
			oa+=( ${x} )
		fi
	done
	echo "${oa[@]}"
}

# smlnj 110.82 is still only 32 bit.  On a multilib 64 bit system
# smlnj_get_libdir tries to find the 32 bit lib directory.  Or otherwise,
# just return the system lib directory $(get_libdir).
smlnj_get_libdir() {
	local x=$(get_all_libdirs)
	# Remove the native lib dir
	local y=$(remove_element_from_array $(get_libdir) ${x[@]})
	# Remove libx32 if it exists
	local z=$(remove_element_from_array "libx32" ${y[@]})
	# However if the system is not multlib, then we still need to install
	# the 32 bit smlnj executables and libraries somewhere, so I guess we
	# just have to put them under the system lib directory.  Put the
	# native lib dir back on the end of the array.
	z+=( $(get_libdir) )
	# Then return the first element of the array, which should be the 32 bit
	# lib directory on multilib systems, or the 32 bit lib directory on
	# 32 bit systems, or the system 64 bit lib directory on non-multilib
	# 64 bit systems.
	echo ${z[0]}
}

src_install() {
	SUBDIR=$(smlnj_get_libdir)/${PN}
	DIR=/usr/${SUBDIR}
	for file in bin/{*,.*}; do
		[[ -f ${file} ]] && sed -e "2iSMLNJ_HOME=${EPREFIX}/${DIR}" \
								-e "s:${WORKDIR}:${EPREFIX}/${DIR}:" -i ${file}
	done
	dodir ${DIR}/bin
	exeinto ${DIR}/bin
	pushd bin || die
	for i in .arch-n-opsys .link-sml .run-sml heap2exec ml-* sml; do
		doexe ${i}
	done
	for i in heap2exec ml-* sml; do
		dosym ../${SUBDIR}/bin/${i} /usr/bin/${i}
	done
	popd || die
	dodir ${DIR}/bin/.heap
	insinto ${DIR}/bin/.heap
	doins bin/.heap/*
	dodir ${DIR}/bin/.run
	exeinto ${DIR}/bin/.run
	pushd bin/.run || die
	for i in run*; do
		doexe ${i}
	done
	popd || die
	insinto ${DIR}
	doins -r lib
	dodoc -r doc/*
}
