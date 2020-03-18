# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LCOV_V=${PV/_p*/}
DB_V=${PV/*_p/}

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/linux-test-project/lcov.git"
	inherit git-r3
else
	SRC_URI="
		mirror://sourceforge/ltp/${PN}-${LCOV_V}.tar.gz
		mirror://debian/pool/main/l/${PN}/${PN}_${LCOV_V}-${DB_V}.debian.tar.xz
	"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-linux ~x64-macos"
fi

inherit prefix

DESCRIPTION="A graphical front-end for GCC's coverage testing tool gcov"
HOMEPAGE="http://ltp.sourceforge.net/coverage/lcov.php"

LICENSE="GPL-2+"
SLOT="0"
IUSE="png"

RDEPEND="
	dev-lang/perl
	dev-perl/JSON
	dev-perl/PerlIO-gzip
	png? ( dev-perl/GD[png] )
"

PATCHES=(
	"${WORKDIR}/debian/patches/handle-equals-signs.patch"
	"${WORKDIR}/debian/patches/fix-undef-behaviour.patch"
	"${WORKDIR}/debian/patches/reproducibility.patch"
	"${WORKDIR}/debian/patches/gcc8.patch"
	"${WORKDIR}/debian/patches/gcc-9-support.patch"
)

S=${WORKDIR}/${PN}-${LCOV_V}

src_prepare() {
	default
	if use prefix; then
		hprefixify bin/*.{pl,sh}
	fi

	# Broken by https://github.com/linux-test-project/lcov/commit/75fbae1cfc5027f818a0bb865bf6f96fab3202da
	rm -rf test/lcov_diff || die
}

src_compile() { :; }

src_install() {
	emake PREFIX="${ED}/usr" CFG_DIR="${ED}/etc" install
}
