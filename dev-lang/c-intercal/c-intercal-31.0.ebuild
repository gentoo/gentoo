# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common

# C-INTERCAL uses minor-major ordering of version components and
# negative version numbers. We map version components -1, -2, ...
# to 65535, 65534, ..., and subtract one from the next component.
# For example, upstream version 0.28 is mapped to Gentoo version 28.0
# and 0.-2.0.29 is mapped to 28.65535.65534.0.
#get_intercal_version() {
#	local i=.${1:-${PV}} j k c=0
#	while [[ ${i} ]]; do
#		(( k = ${i##*.} + c ))
#		(( (c = (k >= 32768)) && (k -= 65536) ))
#		i=${i%.*}
#		j=${j}.${k}
#	done
#	echo ${j#.}
#}

MY_P="${PN#c-}-$(ver_cut 2).$(ver_cut 1)"
DESCRIPTION="C-INTERCAL - INTERCAL to binary (via C) compiler"
HOMEPAGE="http://www.catb.org/~esr/intercal/
	https://gitlab.com/esr/intercal"
SRC_URI="http://www.catb.org/~esr/intercal/${MY_P}.tar.gz"

LICENSE="GPL-2+ FDL-1.2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs examples"

RDEPEND="emacs? ( >=app-editors/emacs-23.1:* )"
BDEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc"

S="${WORKDIR}/${MY_P}"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	eapply "${FILESDIR}"/${P}-version.patch
	eapply_user
	eautoreconf
}

src_compile() {
	emake

	if use emacs; then
		elisp-compile etc/intercal.el
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc BUGS NEWS HISTORY README doc/THEORY.txt

	if use emacs; then
		elisp-install ${PN} etc/intercal.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	use examples && dodoc -r pit
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
