# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Bumping notes:
# * Remember to modify LAST_KNOWN_AUTOMAKE_VER 'upstream' in dev-build/automake-wrapper
# on new automake (major) releases, as well as the dependency in RDEPEND below too.
# * Update _WANT_AUTOMAKE and _automake_atom case statement in autotools.eclass.

PYTHON_COMPAT=( python3_{10..12} )

inherit python-any-r1

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/r/${PN}.git"
	inherit git-r3
else
	if [[ ${PV/_beta} == ${PV} ]]; then
		MY_P="${P}"
		SRC_URI="
			mirror://gnu/${PN}/${P}.tar.xz
			https://alpha.gnu.org/pub/gnu/${PN}/${MY_P}.tar.xz
			https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-1.16.5-tests-c99.patch.xz
		"
		KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	else
		MY_PV="$(ver_cut 1).$(($(ver_cut 2)-1))b"
		MY_P="${PN}-${MY_PV}"

		# Alpha/beta releases are not distributed on the usual mirrors.
		SRC_URI="https://alpha.gnu.org/pub/gnu/${PN}/${MY_P}.tar.xz"
	fi

	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="https://www.gnu.org/software/automake/"

LICENSE="GPL-2"
# Use Gentoo versioning for slotting.
SLOT="${PV:0:4}"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/perl-5.6
	>=dev-build/automake-wrapper-11
	>=dev-build/autoconf-2.69:*
	sys-devel/gnuconfig
"
BDEPEND="
	app-alternatives/gzip
	sys-apps/help2man
	dev-build/autoconf-wrapper
	dev-build/autoconf
	test? (
		${PYTHON_DEPS}
		dev-util/dejagnu
		sys-devel/bison
		sys-devel/flex
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.16.5-py3-compile.patch
	"${FILESDIR}"/${PN}-1.16.5-fix-instmany-python.sh-test.patch
	"${FILESDIR}"/${PN}-1.16.5-fix-py-compile-basedir.sh-test.patch
	"${FILESDIR}"/${PN}-1.16.5-apostrophe-in-tests.patch
	"${FILESDIR}"/${PN}-1.16.5-parallel-build.patch
	"${FILESDIR}"/${PN}-1.16.5-py312.patch
	"${WORKDIR}"/${PN}-1.16.5-tests-c99.patch
)

pkg_setup() {
	# Avoid python-any-r1_pkg_setup
	:
}

src_prepare() {
	default

	export WANT_AUTOCONF=2.5
	# Don't try wrapping the autotools - this thing runs as it tends
	# to be a bit esoteric, and the script does `set -e` itself.
	./bootstrap || die
	sed -i -e "/APIVERSION=/s:=.*:=${SLOT}:" configure || die

	# bug #628912
	if ! has_version -b sys-apps/texinfo ; then
		touch doc/{stamp-vti,version.texi,automake.info} || die
	fi
}

src_configure() {
	use test && python_setup
	# Also used in install.
	MY_INFODIR="${EPREFIX}/usr/share/automake-${PV}/info"
	econf --infodir="${MY_INFODIR}"
}

src_test() {
	# Fails with byacc/flex
	emake YACC="bison -y" LEX="flex" check
}

src_install() {
	default

	rm "${ED}"/usr/share/aclocal/README || die
	rmdir "${ED}"/usr/share/aclocal || die
	rm \
		"${ED}"/usr/bin/{aclocal,automake} \
		"${ED}"/usr/share/man/man1/{aclocal,automake}.1 || die

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	local x
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} \
			/usr/share/${PN}-${SLOT}/config.${x}
	done

	# Avoid QA message about pre-compressed file in docs
	local tarfile="${ED}/usr/share/doc/${PF}/amhello-1.0.tar.gz"
	if [[ -f "${tarfile}" ]] ; then
		gunzip "${tarfile}" || die
	fi

	pushd "${D}/${MY_INFODIR}" >/dev/null || die
	for f in *.info*; do
		# Install convenience aliases for versioned Automake pages.
		ln -s "$f" "${f/./-${PV}.}" || die
	done
	popd >/dev/null || die

	local major="$(ver_cut 1)"
	local minor="$(ver_cut 2)"
	local idx="$((99999-(major*1000+minor)))"
	newenvd - "06automake${idx}" <<-EOF
	INFOPATH="${MY_INFODIR}"
	EOF

	docompress "${MY_INFODIR}"
}
