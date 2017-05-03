# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kdepim"
KMMODULE="wizards"
inherit kde4-meta

DESCRIPTION="KDE PIM wizards (noakonadi branch)"
HOMEPAGE="https://launchpad.net/~pali/+archive/ubuntu/kdepim-noakonadi"

IUSE="debug"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	$(add_kdeapps_dep kdepim-kresources)
	$(add_kdeapps_dep kdepimlibs '' 4.14.10_p20160611)
	$(add_kdeapps_dep libkdepim)
"
RDEPEND="${DEPEND}
	!>kde-apps/kdepimlibs-4.14.11_pre20160211
"

KMEXTRACTONLY="
	kmail/
	knotes/
	kresources/groupwise/
	kresources/kolab/
	kresources/slox/
"

src_prepare() {
	ln -s "${EPREFIX}"/usr/include/kdepim-kresources/{kabcsloxprefs.h,kcalsloxprefs.h} \
		kresources/slox/ \
		|| die "Failed to link extra_headers."
	ln -s "${EPREFIX}"/usr/include/kdepim-kresources/{kabc_groupwiseprefs,kcal_groupwiseprefsbase}.h \
		kresources/groupwise/ \
		|| die "Failed to link extra_headers."

	kde4-meta_src_prepare
}
