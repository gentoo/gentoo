# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit versionator

MY_PV="$(replace_all_version_separators '-')"
DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="https://abiword.github.io/enchant/"
SRC_URI="https://github.com/AbiWord/enchant/releases/download/${PN}-${MY_PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

IUSE="aspell +hunspell static-libs test"
REQUIRED_USE="|| ( hunspell aspell )"

# FIXME: depends on unittest++ but through pkgconfig which is a Debian hack, bug #629742
COMMON_DEPENDS="
	>=dev-libs/glib-2.6:2
	aspell? ( app-text/aspell )
	hunspell? ( >=app-text/hunspell-1.2.1:0= )"
RDEPEND="${COMMON_DEPENDS}"

DEPEND="${COMMON_DEPENDS}
	virtual/pkgconfig
"
#	test? ( dev-libs/unittest++ )

DOCS="AUTHORS BUGS ChangeLog HACKING MAINTAINERS NEWS README TODO"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-hunspell150_fix.patch
)

src_prepare() {
	default
	sed -e "/SUBDIRS/ s/unittests//" -i "${S}"/Makefile.{am,in} || die
	sed -e "s/build_zemberek=yes//" -i "${S}"/configure{.ac,} || die # bug 662484, shouldn't be an issue in 2.2
}

src_configure() {
	econf \
		$(use_enable aspell) \
		$(use_enable hunspell myspell) \
		$(use_enable static-libs static) \
		--disable-hspell \
		--disable-ispell \
		--disable-uspell \
		--disable-voikko \
		--disable-zemberek \
		--with-myspell-dir="${EPREFIX}"/usr/share/myspell/
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
