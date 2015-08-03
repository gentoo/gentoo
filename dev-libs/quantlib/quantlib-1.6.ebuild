# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/quantlib/quantlib-1.6.ebuild,v 1.1 2015/08/03 08:29:48 pinkbyte Exp $

EAPI=5

inherit elisp-common eutils toolchain-funcs

MY_P="QuantLib-${PV}"

DESCRIPTION="A comprehensive software framework for quantitative finance"
HOMEPAGE="http://quantlib.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc emacs examples openmp static-libs"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	emacs? ( virtual/emacs )"

DOCS="*.txt"

S="${WORKDIR}/${MY_P}"

SITEFILE="50${PN}-gentoo.el"

pkg_setup() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	epatch_user
}

src_configure() {
	# NOTE: Too fragile for single .pdf or .ps document
	local prog
	for prog in DVIPS LATEX MAKEINDEX PDFLATEX; do
		export ac_cv_path_${prog}=no
	done

	use doc || export ac_cv_path_DOXYGEN=no
	use emacs || export ac_cv_prog_EMACS=no

	# NOTE: --enable-examples will only change noinst_PROGRAMS to bin_PROGRAMS
	econf \
		$(use_enable debug error-functions) \
		$(use_enable debug error-lines) \
		$(use_enable debug tracing) \
		$(use_enable openmp) \
		$(use_enable static-libs static) \
		--enable-examples \
		--with-lispdir="${SITELISP}/${PN}"
}

src_compile() {
	default

	if use doc; then
		pushd Docs >/dev/null
		emake docs-html
		popd >/dev/null
	fi
}

src_install(){
	default
	prune_libtool_files

	if use doc; then
		find Docs \( -name '.time-stamp*' -o -name '*.doxy' -o -name 'Makefile*' \) -delete || die
		insinto "/usr/share/doc/${PF}"
		doins -r Docs
	fi

	if use examples; then
		find Examples -name '.libs' -exec rm -rf {} + || die
		find Examples \( -name '*vc*proj*' -o -name '*.dev' -o -name 'Makefile*' -o -name '*.o' \) -delete || die
		insinto "/usr/share/doc/${PF}"
		doins -r Examples
	fi

	use emacs && elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
