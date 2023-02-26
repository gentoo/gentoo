# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LANGS="af bg ca cs cy da de de-1901 el en eo es et fo fr ga gl he hr hu ia id is
it kk km ku lt lv mi mk ms nb nl nn pl pt pt-BR ro ru sk sl sq sv sw tn uk zu"
inherit autotools flag-o-matic

DESCRIPTION="Spell checker, morphological analyzer library and command-line tool"
HOMEPAGE="https://hunspell.github.io/"
SRC_URI="https://github.com/hunspell/hunspell/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0/$(ver_cut 1-2)"
IUSE="ncurses nls readline static-libs"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	ncurses? ( sys-libs/ncurses:= )
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PDEPEND=""
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

DOCS=( AUTHORS ChangeLog NEWS THANKS license.{hunspell,myspell} README )

PATCHES=(
	# Upstream package creates some executables which names are too generic
	# to be placed in /usr/bin - this patch prefixes them with 'hunspell-'.
	# It modifies a Makefile.am file, hence eautoreconf.
	"${FILESDIR}/${PN}-1.7.0-renameexes.patch"

	"${FILESDIR}/${PN}-1.7.0-tinfo.patch" # bug #692614
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Missing somehow...
	[[ ${CHOST} == *-darwin* ]] && append-libs -liconv

	# I wanted to put the include files in /usr/include/hunspell.
	# You can do that, libreoffice can find them anywhere, just
	# ping me when you do so ; -- scarabeus
	local myeconfargs=(
		$(use_enable nls)
		$(use_with ncurses ui)
		$(use_with readline readline)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	einstalldocs

	find "${ED}" -type f -name '*.la' -delete || die

	# bug #342449
	pushd "${ED}"/usr/$(get_libdir)/ >/dev/null || die
	ln -s lib${PN}{-$(ver_cut 1).$(ver_cut 2).so.0.0.1,.so} || die
	popd >/dev/null || die
}
