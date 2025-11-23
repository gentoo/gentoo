# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common toolchain-funcs

DESCRIPTION="Functional programming language with dependent types"
HOMEPAGE="https://www.cs.bu.edu/~hwxi/atslangweb/
	https://sourceforge.net/projects/ats2-lang/"

SRC_URI="
	http://downloads.sourceforge.net/sourceforge/ats2-lang/ATS2-Postiats-gmp-${PV}.tgz

	https://sources.debian.org/data/main/a/ats2-lang/${PV}-2/debian/patches/deprecated-cl-package
		-> ${PN}-${PV}-2-deprecated-cl-package.patch
	https://sources.debian.org/data/main/a/ats2-lang/${PV}-2/debian/patches/prelude-function-prototypes
		-> ${PN}-${PV}-2-prelude-function-prototypes.patch
"
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

PATCHES=(
	"${FILESDIR}/${PN}-0.4.2-makefile_dist.patch"
	"${DISTDIR}/${PN}-0.4.2-2-deprecated-cl-package.patch"
	"${DISTDIR}/${PN}-0.4.2-2-prelude-function-prototypes.patch"
)

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	sed -i Makefile								\
		-e "/^CFLAGS/s|=| = ${CFLAGS}|"			\
		-e "/^LDFLAGS/s|=| = ${LDFLAGS}|"		\
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

	sed -i contrib/CATS-atscc2js/Makefile		\
		-i src/CBOOT/Makefile					\
		-e "/^AR=/s|ar|$(tc-getAR) ${ARFLAGS}|"	\
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
	emake -j1 DESTDIR="${D}" install

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
