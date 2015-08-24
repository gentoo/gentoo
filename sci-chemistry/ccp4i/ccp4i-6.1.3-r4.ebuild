# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-single-r1 virtualx

MY_PN="${PN%i}"
MY_P="${MY_PN}-${PV}"

#UPDATE="04_03_09"
#PATCHDATE="090511"

SRC="ftp://ftp.ccp4.ac.uk/ccp4"

DESCRIPTION="Protein X-ray crystallography toolkit -- graphical interface"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI="
	${SRC}/${PV}/${MY_P}-core-src.tar.gz
	mirror://gentoo/${P}-arpwarp.patch.bz2
	https://dev.gentoo.org/~jlec/distfiles/${PV}-oasis4.0.patch.bz2"
[[ -n ${UPDATE} ]] && SRC_URI="${SRC_URI} ${SRC}/${PV}/updates/${P}-src-patch-${UPDATE}.tar.gz"
[[ -n ${PATCHDATE} ]] && SRC_URI="${SRC_URI} https://dev.gentoo.org/~jlec/science-dist/${PV}-${PATCHDATE}-updates.patch.bz2"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
LICENSE="ccp4"
IUSE=""

RDEPEND="
	app-shells/tcsh
	media-gfx/graphviz
	>=dev-lang/tk-8.3:0
	>=dev-tcltk/blt-2.4
	sci-libs/ccp4-libs"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PV}-fix-baubles.patch
	"${WORKDIR}"/${P}-arpwarp.patch
	)

src_prepare() {
	epatch ${PATCHES[@]}

	[[ ! -z ${PATCHDATE} ]] && epatch "${WORKDIR}"/${PV}-${PATCHDATE}-updates.patch

	epatch "${WORKDIR}"/${PV}-oasis4.0.patch
	python_fix_shebang ccp4i/ share/dbccp4i/
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	# rm imosflm stuff
	rm -rf "${S}"/ccp4i/{bin/imosflm,imosflm} || die

	rm -rf "${S}"/ccp4i/{bin,etc}/WINDOWS || die

	# This is installed by mrbump
	rm -rf "${S}"/ccp4i/{tasks/{dbviewer.tcl,mrbump.*},templates/mrbump.com,scripts/mrbump.script} || die

	# CCP4Interface - GUI
	insinto /usr/$(get_libdir)/ccp4
	doins -r "${S}"/ccp4i
	exeinto /usr/$(get_libdir)/ccp4/ccp4i/bin
	doexe "${S}"/ccp4i/bin/*
	dosym ../$(get_libdir)/ccp4/ccp4i/bin/ccp4i /usr/bin/ccp4i

	dodir /usr/$(get_libdir)/ccp4/ccp4i/unix

	# dbccp4i
	insinto /usr/share/ccp4
	doins -r "${S}"/share/dbccp4i
}

pkg_postinst() {
	_ccp4-setup() {
		source "${EPREFIX}/etc/profile"
		export USER=root
		bash "${EPREFIX}"/usr/$(get_libdir)/ccp4/ccp4i/bin/ccp4i -h > /dev/null
	}
	VIRTUALX_COMMAND="_ccp4-setup" virtualmake
	echo ""
	elog "ccp4i needs some enviromental settings. So please"
	elog "\t source ${EPREFIX}/etc/profile"
	echo ""
}
