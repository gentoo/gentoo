# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Standard ML of New Jersey compiler and libraries"
HOMEPAGE="http://www.smlnj.org"

BASE_URI="http://smlnj.cs.uchicago.edu/dist/working/${PV}"

SRC_FILES="
doc.tgz

config.tgz

asdl.tgz
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

SRC_URI="
	amd64? ( ${BASE_URI}/boot.amd64-unix.tgz -> ${P}-boot.amd64-unix.tgz )
	ppc?   ( ${BASE_URI}/boot.ppc-unix.tgz -> ${P}-boot.ppc-unix.tgz )
	sparc? ( ${BASE_URI}/boot.sparc-unix.tgz -> ${P}-boot.sparc-unix.tgz )
	x86?   ( ${BASE_URI}/boot.x86-unix.tgz -> ${P}-boot.x86-unix.tgz )
"

for file in ${SRC_FILES} ; do
	SRC_URI+=" ${BASE_URI}/${file} -> ${P}-${file} "
done

S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"

# sparc support should be there but is untested
KEYWORDS="~amd64 ~ppc ~x86"

src_unpack() {
	mkdir -p "${S}" || die
	local file
	for file in ${A} ; do
		if [[ ${file} != ${P}-config.tgz ]] ; then
			cp "${DISTDIR}/${file}" "${S}/${file#${P}-}" || die
		fi
	done

	# make sure we don't use the internet to download anything
	unpack ${P}-config.tgz
	rm config/*.bat || die
	echo SRCARCHIVEURL=\"file:/${S}\" > "${S}"/config/srcarchiveurl

	mkdir base || die  # without this unpacking runtime will fail
	./config/unpack "${S}" runtime || die

	# Unpack asdl to fix autoconf linker check
	unpack "${S}"/asdl.tgz
}

src_prepare() {
	default

	# respect CC et al. (bug 243886)
	sed -e "/^AS/s|as|$(tc-getAS)|" \
		-e "/^CC/s|gcc|$(tc-getCC)|" \
		-e "/^CPP/s|gcc|$(tc-getCC)|" \
		-e "/^CFLAGS/{s|-O[0123s]|| ; s|=|= ${CFLAGS}|}" \
		-i base/runtime/objs/mk.* || die
	sed -e "/^AS/s|as|$(tc-getAS)|" \
		-e "/^AR/s|ar|$(tc-getAR)|" \
		-e "/^CC/s|cc|$(tc-getCC)|" \
		-e "/^CPP/s|/lib/cpp|$(tc-getCPP)|" \
		-e "/^RANLIB/s|ranlib|$(tc-getRANLIB)|" \
		-i base/runtime/objs/makefile || die

	sed -i "s|nm |$(tc-getNM) |g" config/chk-global-names.sh || die
	sed -i "/^AC_PATH_PROG/s|\[ld\]|\[$(tc-getLD)\]|" asdl/configure.ac || die
}

src_compile() {
	local config_opts=( )
	use amd64 && config_opts+=( "-default 64" )  # force 64-bit build for amd64

	SMLNJ_HOME="${S}" ./config/install.sh ${config_opts[@]} ||
		die "compilation failed"
}

src_install() {
	local DIR=/usr/$(get_libdir)/${PN}
	local i

	local file
	for file in bin/{*,.*} ; do
		[[ -f ${file} ]] &&
			sed -e "2iSMLNJ_HOME=${EPREFIX}/${DIR}" \
				-e "s|${WORKDIR}|${EPREFIX}/${DIR}|" \
				-i ${file}
	done

	newbin ./config/_heap2exec heap2exec
	exeinto ${DIR}/bin
	pushd bin || die
	for i in {*,.*} ; do
		[[ -f ${i} ]] && doexe ${i}
	done
	for i in ml-* sml ; do
		dosym ../../${DIR}/bin/${i} /usr/bin/${i}
	done
	popd || die

	exeinto ${DIR}/bin/.run
	pushd bin/.run || die
	for i in run* ; do
		doexe ${i}
	done
	popd || die

	insinto ${DIR}/bin/.heap
	doins bin/.heap/*

	insinto ${DIR}
	doins -r lib
	doman doc/man/man*/*.*
	dodoc -r doc/*
}
