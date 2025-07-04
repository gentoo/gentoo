# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools dot-a elisp-common

# C-INTERCAL uses minor-major ordering of version components and
# negative version numbers. We map any negative version component M
# to _pre<M+10000>, and any subsequent nonnegative component N to _p<N>.
# For example, upstream version 0.33 is mapped to Gentoo version 33.0
# and 0.-2.0.29 is mapped to 29.0_pre9998_p0.
#get_intercal_version() {
#	local j offset=0
#	for i in $(ver_rs 1- " "); do
#		case ${i} in
#			p) offset=0 ;;
#			pre) offset=-10000 ;;
#			*) j="$((i+offset)).${j}"
#		esac
#	done
#	echo ${j%.}
#}

MY_P="${PN#c-}-$(ver_cut 2).$(ver_cut 1)"
DESCRIPTION="C-INTERCAL - INTERCAL to binary (via C) compiler"
HOMEPAGE="http://www.catb.org/~esr/intercal/
	https://gitlab.com/esr/intercal"
SRC_URI="http://www.catb.org/~esr/intercal/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+ FDL-1.2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs examples"

RDEPEND="emacs? ( >=app-editors/emacs-23.1:* )"
BDEPEND="${RDEPEND}
	app-alternatives/lex
	app-alternatives/yacc"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default
	eautoreconf  #948911
}

src_configure() {
	lto-guarantee-fat
	econf
}

src_compile() {
	emake

	if use emacs; then
		elisp-compile etc/intercal.el
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	strip-lto-bytecode  #958377

	if use emacs; then
		elisp-install ${PN} etc/intercal.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	dodoc BUGS NEWS HISTORY README doc/THEORY.txt
	use examples && dodoc -r pit
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
