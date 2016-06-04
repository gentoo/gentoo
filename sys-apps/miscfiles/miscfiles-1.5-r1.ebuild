# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

UNI_PV=6.1.0
DESCRIPTION="Miscellaneous files"
HOMEPAGE="https://savannah.gnu.org/projects/miscfiles/"
# http://www.unicode.org/Public/${UNI_PV}/ucd/UnicodeData.txt
SRC_URI="mirror://gnu/miscfiles/${P}.tar.gz
	mirror://gentoo/UnicodeData-${UNI_PV}.txt.xz"

LICENSE="GPL-2 unicode"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x86-solaris"
IUSE="minimal"

# Collides with older versions/revisions
RDEPEND="!<sys-freebsd/freebsd-share-7.2-r1"
DEPEND="app-arch/xz-utils"

src_prepare() {
	mv "${WORKDIR}"/UnicodeData-${UNI_PV}.txt unicode || die
}

src_configure() {
	econf --datadir="${EPREFIX}"/usr/share/misc
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc NEWS ORIGIN README dict-README

	# not sure if this is still needed ...
	dodir /usr/share/dict
	cd "${ED}"/usr/share/misc
	mv $(awk '$1=="dictfiles"{$1="";$2="";print}' "${S}"/Makefile) ../dict/ || die
	cd ../dict
	ln -s web2 words || die
	ln -s web2a extra.words || die

	if use minimal ; then
		cd "${ED}"/usr/share/dict
		rm -f words extra.words
		gzip -9 *
		ln -s web2.gz words
		ln -s web2a.gz extra.words
		ln -s connectives{.gz,}
		ln -s propernames{.gz,}
		cd ..
		rm -r misc rfc
	fi
}

pkg_postinst() {
	if [[ ${ROOT} == "/" ]] && type -P create-cracklib-dict >/dev/null ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict "${EPREFIX}"/usr/share/dict/* > /dev/null
		eend $?
	fi
}
