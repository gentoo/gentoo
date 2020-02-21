# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic libtool toolchain-funcs

MY_P="${P/_/-}"

DESCRIPTION="A spell checker replacement for ispell"
HOMEPAGE="http://aspell.net/"
if [[ "${PV}" = *_rc* ]] ; then
	SRC_URI="mirror://gnu-alpha/aspell/${MY_P}.tar.gz"
else
	SRC_URI="mirror://gnu/aspell/${MY_P}.tar.gz"
fi

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls unicode"

PDEPEND="app-dicts/aspell-en"
LANGS="af be bg br ca cs cy da de de-1901 el en eo es et fi fo fr ga gl he hr
hu hy is it la lt nl no pl pt pt-BR ro ru sk sl sr sv uk vi"
for lang in ${LANGS}; do
	IUSE+=" l10n_${lang}"
	case ${lang} in
		de-1901) dict="de-alt"  ;;
		pt-BR)   dict="pt-br"   ;;
		*)       dict="${lang}" ;;
	esac
	PDEPEND+=" l10n_${lang}? ( app-dicts/aspell-${dict} )"
done
unset dict lang LANGS

# English dictionary 0.5 is incompatible with aspell-0.6
RDEPEND="
	sys-libs/ncurses:0=[unicode?]
	nls? ( virtual/libintl )
	!=app-dicts/aspell-en-0.5*
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}/${MY_P}"

HTML_DOCS=( manual/aspell{,-dev}.html )
PATCHES=(
	"${FILESDIR}/${PN}-0.60.5-nls.patch"
	"${FILESDIR}/${PN}-0.60.5-solaris.patch"
	"${FILESDIR}/${PN}-0.60.6-darwin-bundles.patch"
	"${FILESDIR}/${PN}-0.60.6.1-clang.patch"
	# includes fix for bug #467602
	"${FILESDIR}/${PN}-0.60.6.1-unicode.patch"
)

src_prepare() {
	default

	rm m4/lt* m4/libtool.m4 || die
	eautoreconf
	elibtoolize --reverse-deps

	# Parallel install of libtool libraries doesn't always work.
	# https://lists.gnu.org/archive/html/libtool/2011-03/msg00003.html
	# This has to be after automake has run so that we don't clobber
	# the default target that automake creates for us.
	echo 'install-filterLTLIBRARIES: install-libLTLIBRARIES' >> Makefile.in || die

	# unicode patch breaks on Darwin, NCURSES_WIDECHAR won't get set
	# any more.  Fix this.
	[[ ${CHOST} == *-darwin* ]] || [[ ${CHOST} == *-musl* ]] && use unicode && \
		append-cppflags -DNCURSES_WIDECHAR=1
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_enable unicode)
		--disable-static
		--sysconfdir="${EPREFIX}"/etc/aspell
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	docinto examples
	dodoc "${S}"/examples/*.c

	# install ispell/aspell compatibility scripts
	newbin scripts/ispell ispell-aspell
	newbin scripts/spell spell-aspell

	# we explicitly pass '--disable-static' to econf,
	# hence we can delete .la files unconditionally
	find "${ED}" -type f -name '*.la' -delete || die
}
