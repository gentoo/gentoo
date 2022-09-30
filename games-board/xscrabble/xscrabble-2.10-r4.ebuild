# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="An X11 clone of the well-known Scrabble"
HOMEPAGE="http://freshmeat.net/projects/xscrabble/?topic_id=80"
SRC_URI="ftp://ftp.ac-grenoble.fr/ge/educational_games/${P}.tgz
	l10n_fr? ( ftp://ftp.ac-grenoble.fr/ge/educational_games/xscrabble_fr.tgz )
	ftp://ftp.ac-grenoble.fr/ge/educational_games/xscrabble_en.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_fr"

DEPEND="x11-libs/libXaw"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
	!<x11-terms/kterm-6.2.0-r7
"
BDEPEND="
	sys-devel/gcc
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1
"

PATCHES=(
	"${FILESDIR}"/${P}-path-fixes.patch
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-implicit-declaration.patch
)

src_unpack() {
	unpack ${P}.tgz
	cp "${DISTDIR}"/xscrabble_en.tgz . || die

	if use l10n_fr ; then
		cp "${DISTDIR}"/xscrabble_fr.tgz . || die
	fi
}

src_prepare() {
	default

	# Don't strip binaries
	sed -i '/install/s/-s //' build || die
	# Respect AR, RANLIB
	sed -i 's/CC="${CC}"/& AR="${AR} cq" RANLIB="${RANLIB}"/' build || die
}

src_configure() {
	# bug #858623
	filter-lto

	tc-export AR CC LD RANLIB
	export IMAKECPP=${IMAKECPP:-${CHOST}-gcc -E}
}

src_compile() {
	./build bin || die "build failed"
}

src_install() {
	export DESTDIR="${ED}" LIBDIR="$(get_libdir)"

	./build install || die "install failed"

	if use l10n_fr ; then
		./build lang fr || die "fr failed"
	fi

	./build lang en || die "en failed"

	local f
	for f in "${ED}/usr/$(get_libdir)"/X11/app-defaults/* ; do
		[[ -L ${f} ]] && continue
		sed -i \
			-e "s:/usr/games/lib/scrabble/:/usr/share/${PN}/:" \
			-e "s:fr/eng:fr/en:" \
			${f} || die "sed ${f} failed"
	done

	dodoc CHANGES README

	local paths=( /usr/share/${PN}/en/scrabble_scores )
	if use l10n_fr ; then
		paths+=( /usr/share/${PN}/fr/scrabble_scores )
	fi

	local path
	for path in ${paths[@]} ; do
		fowners root:gamestat ${path}
		fperms 660 ${path}
	done

	fperms g+s /usr/bin/${PN}
}
