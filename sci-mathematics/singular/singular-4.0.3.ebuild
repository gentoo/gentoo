# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools elisp-common flag-o-matic multilib prefix versionator

MY_PN=Singular
MY_PV=$(replace_all_version_separators '.')
# Consistency is different...
MY_DIR2=$(get_version_component_range 1-3 ${PV})
MY_DIR=$(replace_all_version_separators '-' ${MY_DIR2})
# This is where the share tarball unpacks to

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="http://www.singular.uni-kl.de/"
SRC_URI="http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${PN}-${MY_PV}.tar.gz
		 http://www.mathematik.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${PN}-${MY_PV}-share.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~x86-macos"
IUSE="boost doc emacs examples python +readline"

RDEPEND="dev-libs/gmp:0
	>=dev-libs/ntl-5.5.1
	emacs? ( >=virtual/emacs-22 )
	sci-mathematics/flint
	sci-mathematics/4ti2
	sci-libs/cddlib"

DEPEND="${RDEPEND}
	dev-lang/perl
	boost? ( dev-libs/boost )
	readline? ( sys-libs/readline )"

SITEFILE=60${PN}-gentoo.el

S="${WORKDIR}/${PN}-${MY_DIR2}"

pkg_setup() {
	append-flags "-fPIC"
	append-ldflags "-fPIC"
	tc-export AR CC CPP CXX

	# Ensure that >=emacs-22 is selected
	if use emacs; then
		elisp-need-emacs 22 || die "Emacs version too low"
	fi
}

src_prepare () {
	eapply "${FILESDIR}"/"${P}"-fix-resources-name.patch
	eapply "${FILESDIR}"/"${P}"-fix-destdir.patch
	eapply_user
	# autoreconf everything since otherwise it assumes autmake-1.13 is installed
	eautoreconf
}

src_configure() {
	econf --with-gmp \
		  --with-ntl \
		  --with-flint \
		  --enable-gfanlib \
		  --disable-debug \
		  --disable-doc \
		  --enable-factory \
		  --enable-libfac \
		  --enable-IntegerProgramming \
		  $(use_with python python embed) \
		  $(use_with boost Boost) \
		  $(use_enable emacs) \
		  $(use_with readline) || die "configure failed"
}

src_compile() {
	emake || die "emake failed"

	if use emacs; then
		cd "${S}"/emacs/
		elisp-compile *.el || die "elisp-compile failed"
	fi
}

pkg_postinst() {
	einfo "The authors ask you to register as a SINGULAR user."
	einfo "Please check the license file for details."

	if use emacs; then
		echo
		ewarn "Please note that the ESingular emacs wrapper has been"
		ewarn "removed in favor of full fledged singular support within"
		ewarn "Gentoo's emacs infrastructure; i.e. just fire up emacs"
		ewarn "and you should be good to go! See bug #193411 for more info."
		echo
	fi

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
