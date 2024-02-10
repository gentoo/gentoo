# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="https://www.gnu.org/software/automake/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
# Use Gentoo versioning for slotting.
SLOT="${PV:0:4}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos"
IUSE="test"
RESTRICT="test !test? ( test )"

RDEPEND="
	>=dev-lang/perl-5.6
	>=dev-build/automake-wrapper-10
	>=dev-build/autoconf-2.69:*
	sys-devel/gnuconfig
"
DEPEND="
	${RDEPEND}
	sys-apps/help2man
"
BDEPEND="
	app-arch/gzip
	test? ( dev-util/dejagnu )
"

PATCHES=(
	"${FILESDIR}"/${P}-perl-5.16.patch #424453
	"${FILESDIR}"/${P}-install-sh-avoid-low-risk-race-in-tmp.patch
	"${FILESDIR}"/${P}-perl-escape-curly-bracket-r1.patch
)

src_prepare() {
	default
	export WANT_AUTOCONF=2.5
	export HELP2MAN=true
	sed -i -e "/APIVERSION=/s:=.*:=${SLOT}:" configure || die
	export TZ="UTC"  #589138
}

src_compile() {
	# Also used in install.
	MY_INFODIR="${EPREFIX}/usr/share/automake-${PV}/info"
	econf --infodir="${MY_INFODIR}"

	local x
	for x in aclocal automake; do
		help2man "perl -Ilib ${x}" > doc/${x}-${SLOT}.1
	done
}

src_install() {
	default

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
