# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common toolchain-funcs

DESCRIPTION="Functional programming language with dependent types"
HOMEPAGE="https://www.cs.bu.edu/~hwxi/atslangweb/
	https://sourceforge.net/projects/ats2-lang/"
SRC_URI="http://downloads.sourceforge.net/sourceforge/ats2-lang/ATS2-Postiats-gmp-${PV}.tgz"
S="${WORKDIR}/ATS2-Postiats-gmp-${PV}"

LICENSE="GPL-3+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

RDEPEND="
	dev-libs/gmp:=
	emacs? ( >=app-editors/emacs-25.3:* )
"
DEPEND="
	${RDEPEND}
"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	sed -i Makefile								\
		-e "/^CFLAGS/s|=| = ${CFLAGS}|"			\
		-e "/^LDFLAGS/s|=| = ${LDFLAGS}|"		\
		-e "/^MAKE/s|=make| ?= \$(MAKE)|g"		\
		-e "/^MAKEJ4/s|-j4||"					\
		|| die

	sed -i ccomp/atslib/Makefile				\
		-i src/CBOOT/Makefile					\
		-i utils/atscc/Makefile_build			\
		-i utils/myatscc/Makefile_build			\
		-e "s|ld |$(tc-getLD) |g"				\
		-e "s|-O2|${CFLAGS} ${LDFLAGS}|g"		\
		|| die

	sed -i ccomp/atslib/Makefile					\
		-i src/Makefile								\
		-e "s|ar -r|$(tc-getAR) ${ARFLAGS} -r|g"	\
		|| die

	rm utils/emacs/flycheck-ats2.el || die
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" GCC="$(tc-getCC)" CCOMP="$(tc-getCC)" all

	if use emacs ; then
		cd utils/emacs || die

		elisp-compile ./*.el
	fi
}

src_install() {
	default

	if use emacs ; then
		cd utils/emacs || die

		elisp-install "${PN}" ./*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	local ats2_dir="/usr/lib/${PN}-postiats-${PV}"
	local contrib_dir="${ats2_dir}/contrib"

	# Randomly generated.
	local libatslib="${ED}${ats2_dir}/ccomp/atslib/lib/libatslib.a"
	if [[ -f "${libatslib}" ]] ; then
		rm "${libatslib}" || die
	fi

	# Broken symlinks.
	rm "${ED}${contrib_dir}"/*/*/SATS/DOCUGEN/Makefile.gen || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
