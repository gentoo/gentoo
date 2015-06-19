# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/quantlib/quantlib-1.2.ebuild,v 1.2 2012/03/17 08:54:35 ssuominen Exp $

EAPI=4
inherit elisp-common

MY_P=QuantLib-${PV}

DESCRIPTION="A comprehensive software framework for quantitative finance"
HOMEPAGE="http://quantlib.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs examples static-libs"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	emacs? ( virtual/emacs )"

DOCS="*.txt"

SITEFILE=50${PN}-gentoo.el

S=${WORKDIR}/${MY_P}

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
		$(use_enable static-libs static) \
		--enable-examples \
		--with-lispdir="${SITELISP}"/${PN}
}

src_compile() {
	emake

	if use doc; then
		pushd Docs >/dev/null
		nonfatal emake docs-html
		popd >/dev/null
	fi
}

src_install(){
	default

	rm -f "${ED}"/usr/lib*/*.la

	if use doc; then
		find Docs \( -name '.time-stamp*' -o -name '*.doxy' -o -name 'Makefile*' \) -delete
		insinto /usr/share/doc/${PF}
		nonfatal doins -r Docs
	fi

	if use examples; then
		find Examples \( -name '*vc*proj*' -o -name '*.dev' -o -name 'Makefile*' -o -name '.libs' -o -name '*.o' \) -delete
		insinto /usr/share/doc/${PF}
		nonfatal doins -r Examples
	fi

	use emacs && elisp-site-file-install "${FILESDIR}"/${SITEFILE}
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
