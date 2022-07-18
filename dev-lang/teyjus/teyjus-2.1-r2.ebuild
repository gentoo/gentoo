# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common

DESCRIPTION="Higher-order logic programming language Lambda Prolog"
HOMEPAGE="http://teyjus.cs.umn.edu/"
SRC_URI="https://github.com/teyjus/teyjus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
IUSE="emacs examples"

RDEPEND="dev-lang/ocaml[ocamlopt]
	emacs? ( >=app-editors/emacs-23.1:* )"
DEPEND="${RDEPEND}
	app-text/dos2unix
	dev-util/omake"

SITEFILE=50${PN}-gentoo.el

PATCHES=( "${FILESDIR}/${P}-p001-Fixes-arity-for-pervasive-modulo-operation.patch"
		  "${FILESDIR}/${P}-p002-Add-string-literals-from-proper-character-groups.patch"
		  "${FILESDIR}/${P}-p003-Removing-deprecated-function-String.set.patch"
		  "${FILESDIR}/${P}-p004-Renaming-ccode_stubs-for-compilation.patch"
		  "${FILESDIR}/${P}-p005-Unbundle-ocaml-header-files.patch"
		  "${FILESDIR}/${P}-p006-Version.patch" )

src_prepare() {
	rm -rf source/front/caml \
		|| die "Could not remove bundled ocaml header files"
	find . -type f -exec dos2unix --quiet {} \; \
		|| die "Could not convert files from DOS to Unix format"
	mv source/front/ccode_stubs.c source/front/ccode_stubs_c.c \
	   || die "Could not rename source/front/ccode_stubs.c to source/front/ccode_stubs_c.c"
	mv source/front/ccode_stubs.mli source/front/ccode_stubs.ml \
	   || die "Could not rename source/front/ccode_stubs.mli to source/front/ccode_stubs.ml"
	default
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
	local bs="LDFLAGS += ${LDFLAGS}\n"
	bs+="CC = ${CC:-gcc}\n"
	bs+="CPP = ${CPP:-cpp}\n"
	bs+="LD = ${LD:-ld}\n"
	bs+="AR(name) =\n"
	bs+="    return(${AR:-ar} cq \$(name))\n"
	bs+="AS = ${AS:-as}\n"
	bs+="RANLIB = ${RANLIB:-ranlib}"
	sed	-e "s@\(OCAMLFLAGS= -w -A\)@\1 -cc ${CC:-gcc} ${cflags}${lflags}@" \
		-e "s@\(CFLAGS +=\) -g@\1 ${CFLAGS}\n${bs}@" \
		-i "${S}/source/OMakefile" \
		|| die "Could not set flags in ${S}/source/OMakefile"
}

src_compile() {
	export HOME="${T}"
	omake --verbose --force-dotomake all || die "omake all failed"
	if use emacs ; then
		pushd "${S}/emacs" || die "Could change directory to emacs"
		elisp-compile *.el || die "emacs elisp compile failed"
		popd
	fi
}

ins_example_dir() {
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
	dodoc README.md QUICKSTART
	if use emacs ; then
		elisp-install ${PN} emacs/*.{el,elc}
		cp "${FILESDIR}"/${SITEFILE} "${S}"
		sed -e "s@/usr/bin/tjcc@${EPREFIX}/usr/bin/tjcc@" -i ${SITEFILE} \
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
