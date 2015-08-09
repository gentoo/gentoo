# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit base elisp-common multilib versionator

MY_PN="${PN}-source"
MY_P=$(version_format_string '${MY_PN}-$1.$2-b$3')

DESCRIPTION="Higher-order logic programming language Lambda Prolog"
HOMEPAGE="http://teyjus.cs.umn.edu/"
SRC_URI="http://teyjus.googlecode.com/files/${MY_P}.tar.gz"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
IUSE="emacs examples +ocamlopt"

RDEPEND=">=sys-devel/binutils-2.17
	>=sys-devel/gcc-2.95.3
	>=dev-lang/ocaml-3.10[ocamlopt?]
	emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}
	dev-util/omake"

S=${WORKDIR}/${PN}

PATCHES=("${FILESDIR}/${PN}-2.0.2-flags.patch")

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	base_src_prepare
	local cflags=""
	for i in ${CFLAGS}
	do
		cflags="${cflags} -ccopt ${i}"
	done
	local lflags=""
	for i in ${LDFLAGS}
	do
		lflags="${lflags} -cclib ${i}"
	done
	sed -e "s@CFLAGS +=@CFLAGS += ${CFLAGS}@" \
		-e "s@LDFLAGS +=@LDFLAGS += ${LDFLAGS}@" \
		-e "s@OCAMLFLAGS +=@OCAMLFLAGS +=${cflags}${lflags}@" \
		-i "${S}/source/OMakefile" \
		|| die "Could not set flags in ${S}/teyjus/source/OMakefile"
}

src_compile() {
	addpredict "/usr/$(get_libdir)/omake/Pervasives.omc"
	addpredict "/usr/$(get_libdir)/omake/build/C.omc"
	addpredict "/usr/$(get_libdir)/omake/build/Common.omc"
	addpredict "/usr/$(get_libdir)/omake/configure/Configure.omc"
	addpredict "/usr/$(get_libdir)/omake/build/OCaml.omc"
	omake --verbose all || die "omake all failed"
	if use emacs ; then
		pushd "${S}/emacs" || die "Could change directory to emacs"
		elisp-compile *.el || die "emacs elisp compile failed"
		popd
	fi
}

ins_example_dir() {
	dodir "/usr/share/${PN}/examples/${1}"
	insinto "/usr/share/${PN}/examples/${1}"
	cd "${S}/examples/${1}"
	doins *
}

src_install() {
	newbin source/tjcc.opt tjcc
	newbin source/tjdepend.opt tjdepend
	newbin source/tjdis.opt tjdis
	newbin source/tjlink.opt tjlink
	newbin source/tjsim.opt tjsim
	dodoc README
	if use emacs ; then
		elisp-install ${PN} emacs/*.{el,elc}
		cp "${FILESDIR}"/${SITEFILE} "${S}"
		sed -e 's@/usr/bin/tjcc@'${EPREFIX}/usr/bin/tjcc'@' -i ${SITEFILE} \
			|| die "Could not set tjcc executable path in emacs site file"
		elisp-site-file-install ${SITEFILE}
	fi
	if use examples; then
		ins_example_dir "handbook/logic"
		ins_example_dir "handbook/progs"
		ins_example_dir "misc"
		ins_example_dir "ndprover"
		ins_example_dir "pcf"
	fi
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		ewarn "For teyjus emacs, add this line to ~/.emacs"
		ewarn ""
		ewarn "(require 'teyjus)"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
