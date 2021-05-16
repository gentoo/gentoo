# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit elisp-common multilib

DESCRIPTION="Higher-order logic programming language Lambda Prolog"
HOMEPAGE="http://teyjus.cs.umn.edu/"
SRC_URI="https://github.com/teyjus/teyjus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
IUSE="emacs examples +ocamlopt"

RDEPEND=">=sys-devel/binutils-2.17:*
	>=sys-devel/gcc-2.95.3:*
	>=dev-lang/ocaml-3.10[ocamlopt?]
	emacs? ( >=app-editors/emacs-23.1:* )"
DEPEND="${RDEPEND}
	app-text/dos2unix
	dev-util/omake"

SITEFILE=50${PN}-gentoo.el

PATCHES=( "${FILESDIR}/${P}-p001-Fixes-arity-for-pervasive-modulo-operation.patch"
		  "${FILESDIR}/${P}-p002-Add-string-literals-from-proper-character-groups.patch"
		  "${FILESDIR}/${P}-p003-Removing-deprecated-function-String.set.patch")

src_prepare() {
	find . -type f -exec dos2unix {} \;
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
	sed	-e "s@\(OCAMLFLAGS= -w -A\)@\1 ${cflags}${lflags}@" \
		-e "s@\(CFLAGS +=\) -g@\1 ${CFLAGS}\nLDFLAGS += ${LDFLAGS}@" \
		-i "${S}/source/OMakefile" \
		|| die "Could not set flags in ${S}/teyjus/source/OMakefile"
	if has_version ">=dev-lang/ocaml-4.03.0"; then
		# bug 591368
		pushd "${S}/source" || die
		sed -e 's@$(FNT)/ccode_stubs@$(FNT)/ccode_stubs_c@' \
			-e 's@\(FNT_ML_TO_C\[\] =\)@\1\n    $(FNT)/ccode_stubs@' \
			-i OMakefile || die
		cd "${S}/source/front" || die
		mv ccode_stubs.mli ccode_stubs.ml || die
		mv ccode_stubs.c ccode_stubs_c.c || die
		popd || die
	fi
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
	dodoc README.md QUICKSTART
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
