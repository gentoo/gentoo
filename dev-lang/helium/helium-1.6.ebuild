# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools eutils

DESCRIPTION="Helium (for learning Haskell)"
HOMEPAGE="http://www.cs.uu.nl/helium"
SRC_URI="http://www.cs.uu.nl/helium/distr/${P}-src.tar.gz
	mirror://gentoo/${P}-ghc.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
# compilation breaks on amd64, suspect lvm doesn't work properly
KEYWORDS="-amd64 ~ppc -sparc ~x86"
IUSE="readline"

DEPEND=">=dev-lang/ghc-6.8
	dev-haskell/mtl
	dev-haskell/parsec
	readline? ( dev-haskell/readline )"
RDEPEND="dev-libs/gmp
	readline? ( sys-libs/readline )"

src_unpack() {
	unpack ${A}
	epatch "${P}-ghc.patch"
	epatch "${FILESDIR}/helium-1.6-respect-cflags-ldflags-nostrip.patch"

	# split base only
	sed -e 's/^GHCFLAGS =.*$/& -package containers/' \
	    -i "${S}/helium/src/Makefile.in"

	# file has non-ASCII syms and it's pulled to ghc for dependency generaton
	# ghc w/UTF-8 dislikes it:
	sed -e 's/\xCA//g' \
	    -i "${S}/helium/src/Makefile.in"

	# mangle evil 'rec' to 'rec_'. It's not very accurate, but less,
	# than manually patching ~250 occurences. (ghc-6.10+ has rec as reserved word)
	local bad_file

	for bad_file in Top/src/Top/Types/Unification.hs \
			Top/src/Top/Types/Quantification.hs \
			Top/src/Top/Types/Primitive.hs \
			Top/src/Top/Solver/PartitionCombinator.hs \
			Top/src/Top/Repair/Repair.hs \
			Top/src/Top/Ordering/Tree.hs \
			Top/src/Top/Implementation/TypeGraph/Standard.hs \
			Top/src/Top/Implementation/TypeGraph/Path.hs \
			Top/src/Top/Implementation/TypeGraph/EquivalenceGroup.hs \
			Top/src/Top/Implementation/TypeGraph/Basics.hs \
			Top/src/Top/Implementation/TypeGraph/ApplyHeuristics.hs \
			lvm/src/lib/lvm/LvmRead.hs \
			lvm/src/lib/core/CoreNoShadow.hs \
			helium/src/utils/LoggerEnabled.hs \
			helium/src/staticanalysis/miscellaneous/TypesToAlignedDocs.hs \
			helium/src/staticanalysis/miscellaneous/TypeConversion.hs \
			helium/src/staticanalysis/inferencers/TypeInferencing.hs \
			helium/src/staticanalysis/heuristics/RepairSystem.hs \
			helium/src/staticanalysis/heuristics/RepairHeuristics.hs \
			helium/src/staticanalysis/heuristics/ListOfHeuristics.hs \
			helium/src/staticanalysis/directives/TS_PatternMatching.ag
	do
		# take all symbols from exactly this source. This set is not universal,
		# but it aims to catch (same) lexeme separators on the left and on the right
		sed -e 's/\([^a-zA-Z_0-9"]\|^\)rec\([^a-zA-Z_0-9"]\|$\)/\1rec_\2/g' \
	    -i "${S}/$bad_file"
	done

	# cabal is their friend (oneOf became polymorphic and breaks the test)
	sed -e 's/Text.ParserCombinators.Parsec/&.Pos/g' \
	    -e 's/oneOf/newPos/g' \
	    -i "${S}/helium/configure.in"

	cd "${S}/helium"
	eautoreconf
}

src_compile() {
	# helium consists of two components that have to be set up separately,
	# lvm and the main compiler. both build systems are slightly strange.
	# lvm uses a completely non-standard build system:
	# the ./configure of lvm is not the usual autotools configure

	cd "${S}/lvm/src" && ./configure || die "lvm configure failed"
	echo "STRIP=echo" >> config/makefile || die "lvm postconfigure failed"
	myconf="$(use_enable readline) --without-strip --without-upx --without-ag"
	cd "${S}/helium" && econf --prefix="/usr/lib" ${myconf} || die "econf failed"
	cd "${S}/helium/src" && make depend || die "make depend failed"

	emake -j1 || die "make failed"
}

src_install() {
	cd helium/src || die "cannot cd to helium/src"
	make install bindir="/usr/lib/helium/bin" DESTDIR="${D}" || die "make install failed"

	# create wrappers
	newbin "${FILESDIR}/helium-wrapper-${PV}" helium-wrapper

	dosym /usr/bin/helium-wrapper /usr/bin/texthint
	dosym /usr/bin/helium-wrapper /usr/bin/helium
	dosym /usr/bin/helium-wrapper /usr/bin/lvmrun
}
