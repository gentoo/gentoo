# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/fpc/fpc-2.6.2.ebuild,v 1.8 2014/08/05 11:31:58 armin76 Exp $

EAPI=5

inherit toolchain-funcs

HOMEPAGE="http://www.freepascal.org/"
DESCRIPTION="Free Pascal Compiler"
SRC_URI="mirror://sourceforge/freepascal/fpcbuild-${PV}.tar.gz
	amd64? ( mirror://sourceforge/freepascal/${P}.x86_64-linux.tar )
	arm? ( mirror://sourceforge/freepascal/${P}.arm-linux.tar )
	ppc? ( mirror://sourceforge/freepascal/${P}.powerpc-linux.tar )
	ppc64? ( mirror://sourceforge/freepascal/${P}.powerpc64-linux.tar )
	sparc? ( mirror://sourceforge/freepascal/${P}.sparc-linux.tar )
	x86? ( mirror://sourceforge/freepascal/${P}.i386-linux.tar )
	doc? ( mirror://sourceforge/freepascal/Documentation/${PV}/doc-html.tar.gz -> ${P}-doc-html.tar.gz
		http://dev.gentoo.org/~radhermit/distfiles/${P}-fpctoc.htx.bz2 )"

SLOT="0"
LICENSE="GPL-2 LGPL-2.1-with-linking-exception"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="doc ide source"

RDEPEND="ide? ( !dev-lang/fpc-ide )"

RESTRICT="strip" #269221

S=${WORKDIR}/fpcbuild-${PV}/fpcsrc

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# Bug 475210
		if $(tc-getLD) --version | grep -q "GNU gold"; then
			eerror "fpc does not function correctly when built with the gold linker."
			eerror "Please select the bfd linker with binutils-config."
			die "GNU gold detected"
		fi
	fi
}

src_unpack() {
	case ${ARCH} in
	amd64)	FPC_ARCH="x86_64"    PV_BIN=${PV} ;;
	arm)	FPC_ARCH="arm"       PV_BIN=${PV} ;;
	ppc)	FPC_ARCH="powerpc"   PV_BIN=${PV} ;;
	ppc64)	FPC_ARCH="powerpc64" PV_BIN=${PV} ;;
	sparc)	FPC_ARCH="sparc"     PV_BIN=${PV} ;;
	x86)	FPC_ARCH="i386"      PV_BIN=${PV} ;;
	*)	die "This ebuild doesn't support ${ARCH}." ;;
	esac

	unpack ${A}

	tar -xf ${P}.${FPC_ARCH}-linux/binary.${FPC_ARCH}-linux.tar || die "Unpacking binary.${FPC_ARCH}-linux.tar failed!"
	tar -xzf base.${FPC_ARCH}-linux.tar.gz || die "Unpacking base.${FPC_ARCH}-linux.tar.gz failed!"
}

src_prepare() {
	find "${WORKDIR}" -name Makefile -exec sed -i -e 's/ -Xs / /g' {} + || die

	# let the pkg manager compress man files
	sed -i '/find man.* gzip /d' "${WORKDIR}"/fpcbuild-${PV}/install/man/Makefile || die
}

set_pp() {
	case ${ARCH} in
	amd64)	FPC_ARCH="x64" ;;
	arm)	FPC_ARCH="arm" ;;
	ppc)	FPC_ARCH="ppc" ;;
	ppc64)	FPC_ARCH="ppc64" ;;
	sparc)	FPC_ARCH="sparc" ;;
	x86)	FPC_ARCH="386" ;;
	*)	die "This ebuild doesn't support ${ARCH}." ;;
	esac

	case ${1} in
	bootstrap)	pp="${WORKDIR}"/lib/fpc/${PV_BIN}/ppc${FPC_ARCH} ;;
	new) 	pp="${S}"/compiler/ppc${FPC_ARCH} ;;
	*)	die "set_pp: unknown argument: ${1}" ;;
	esac
}

src_compile() {
	local pp

	# Using the bootstrap compiler.
	set_pp bootstrap

	emake -j1 PP="${pp}" compiler_cycle AS="$(tc-getAS)"

	# Save new compiler from cleaning...
	cp "${S}"/compiler/ppc${FPC_ARCH} "${S}"/ppc${FPC_ARCH}.new || die

	# ...rebuild with current version...
	emake -j1 PP="${S}"/ppc${FPC_ARCH}.new AS="$(tc-getAS)" compiler_cycle

	# ..and clean up afterwards
	rm "${S}"/ppc${FPC_ARCH}.new || die

	# Using the new compiler.
	set_pp new

	emake -j1 PP="${pp}" AS="$(tc-getAS)" rtl_clean

	emake -j1 PP="${pp}" AS="$(tc-getAS)" rtl packages_all utils

	if use ide ; then
		cd "${S}"/ide || die
		emake -j1 PP="${pp}" AS="$(tc-getAS)"
	fi
}

src_install() {
	local pp
	set_pp new

	set -- PP="${pp}" FPCMAKE="${S}/utils/fpcm/fpcmake" \
		INSTALL_PREFIX="${D}"/usr \
		INSTALL_DOCDIR="${D}"/usr/share/doc/${PF} \
		INSTALL_MANDIR="${D}"/usr/share/man \
		INSTALL_SOURCEDIR="${D}"/usr/lib/fpc/${PV}/source

	emake -j1 "$@" compiler_install rtl_install packages_install utils_install

	dosym ../lib/fpc/${PV}/ppc${FPC_ARCH} /usr/bin/ppc${FPC_ARCH}

	cd "${S}"/../install/doc || die
	emake -j1 "$@" installdoc

	cd "${S}"/../install/man || die
	emake -j1 "$@" installman

	if use doc ; then
		cd "${S}"/../../doc || die
		dodoc -r *
		newdoc "${WORKDIR}"/${P}-fpctoc.htx fpctoc.htx
		docompress -x /usr/share/doc/${PF}/fpctoc.htx
	fi

	if use ide ; then
		cd "${S}"/ide
		emake -j1 "$@" install
	fi

	if use source ; then
		cd "${S}" || die
		shift
		emake -j1 PP="${D}"/usr/bin/ppc${FPC_ARCH} "$@" sourceinstall
		find "${D}"/usr/lib/fpc/${PV}/source -name '*.o' -exec rm {} \;
	fi

	"${D}"/usr/lib/fpc/${PV}/samplecfg "${D}"/usr/lib/fpc/${PV} "${D}"/etc || die

	sed -i "s:${D}::g" "${D}"/etc/fpc.cfg || die

	if use ide ; then
		sed -e "s:${D}::g" \
			-i "${D}"/etc/fppkg.cfg \
			-i "${D}"/etc/fppkg/* \
			-i "${D}"/usr/lib/fpc/${PV}/ide/text/fp*.cfg \
			|| die
	fi

	rm -r "${D}"/usr/lib/fpc/lexyacc || die
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] && use ide; then
		einfo "To read the documentation in the fpc IDE, enable the doc USE flag"
		einfo "and add /usr/share/doc/${PF}/fpctoc.htx to the Help Files list."
	fi
}
