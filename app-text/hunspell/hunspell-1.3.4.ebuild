# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils multilib autotools flag-o-matic versionator

MY_P=${PN}-${PV/_beta/b}

DESCRIPTION="Hunspell spell checker - an improved replacement for myspell in OOo"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="http://hunspell.sourceforge.net/"

SLOT="0"
LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
IUSE="ncurses nls readline static-libs"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	ncurses? ( sys-libs/ncurses:0= )
	readline? ( sys-libs/readline:= )"
DEPEND="${RDEPEND}
	sys-devel/gettext"

LANGS="af bg ca cs cy da de de-1901 el en eo es et fo fr ga gl he hr hu ia id
is it km ku lt lv mi mk ms nb nl nn pl pt pt-BR ro ru sk sl sq sv sw tn uk zu"

PDEPEND="app-dicts/myspell-en"
for lang in ${LANGS}; do
	IUSE+=" l10n_${lang}"
	case ${lang} in
		de-1901) dict="de_1901" ;;
		pt-BR)   dict="pt-br"   ;;
		*)       dict="${lang}" ;;
	esac
	PDEPEND+=" l10n_${lang}? ( app-dicts/myspell-${dict} )"
done
unset dict lang LANGS

S=${WORKDIR}/${MY_P}

DOCS=(
	AUTHORS ChangeLog NEWS README THANKS TODO license.hunspell
	AUTHORS.myspell README.myspell license.myspell
)

PATCHES=(
	# Upstream package creates some executables which names are too generic
	# to be placed in /usr/bin - this patch prefixes them with 'hunspell-'.
	# It modifies a Makefile.am file, hence eautoreconf.
	"${FILESDIR}/${PN}-1.3.4-renameexes.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# missing somehow, and I am too lazy to fix it properly
	[[ ${CHOST} == *-darwin* ]] && append-libs -liconv

	# I wanted to put the include files in /usr/include/hunspell.
	# You can do that, libreoffice can find them anywhere, just
	# ping me when you do so ; -- scarabeus
	econf \
		$(use_enable nls) \
		$(use_with ncurses ui) \
		$(use_with readline readline) \
		$(use_enable static-libs static)
}

src_install() {
	default

	einstalldocs

	prune_libtool_files --all

	#342449
	pushd "${ED}"/usr/$(get_libdir)/ >/dev/null
	ln -s lib${PN}{-$(get_major_version).$(get_version_component_range 2).so.0.0.0,.so}
	popd >/dev/null
}
