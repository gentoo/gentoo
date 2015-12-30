# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kdepim"
KMMODULE="wizards"
inherit kde4-meta

DESCRIPTION="KDE PIM wizards (noakonadi branch)"
IUSE="debug"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.6)
	$(add_kdeapps_dep kdepim-kresources '' 4.4.2015)
	$(add_kdeapps_dep libkdepim '' 4.4.2015)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	kmail/
	knotes/
	kresources/groupwise/
	kresources/kolab/
	kresources/slox/
"

PATCHES=( "${FILESDIR}/${PN}-4.4.11.1-underlinking.patch" )

src_prepare() {
	ln -s "${EKDEDIR}"/include/kdepim-kresources/{kabcsloxprefs.h,kcalsloxprefs.h} \
		kresources/slox/ \
		|| die "Failed to link extra_headers."
	ln -s "${EKDEDIR}"/include/kdepim-kresources/{kabc_groupwiseprefs,kcal_groupwiseprefsbase}.h \
		kresources/groupwise/ \
		|| die "Failed to link extra_headers."

	kde4-meta_src_prepare
}
