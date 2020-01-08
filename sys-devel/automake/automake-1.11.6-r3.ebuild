# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="https://www.gnu.org/software/automake/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
# Use Gentoo versioning for slotting.
SLOT="${PV:0:4}"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/perl
	>=sys-devel/automake-wrapper-10
	>=sys-devel/autoconf-2.69:*
	sys-devel/gnuconfig"
DEPEND="${RDEPEND}
	sys-apps/help2man
	test? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10-perl-5.16.patch #424453
	"${FILESDIR}"/${PN}-1.11-install-sh-avoid-low-risk-race-in-tmp.patch
	"${FILESDIR}"/${PN}-1.13-perl-escape-curly-bracket-r1.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	export WANT_AUTOCONF=2.5
	chmod a+rx tests/*.test
	export HELP2MAN=true
	sed -i -e "/APIVERSION=/s:=.*:=${SLOT}:" configure || die
	export TZ="UTC"  #589138
}

src_configure() {
	econf --docdir="\$(datarootdir)/doc/${PF}"
}

src_compile() {
	default

	local x
	for x in aclocal automake; do
		help2man "perl -Ilib ${x}" > doc/${x}-${SLOT}.1
	done
}

# slot the info pages.  do this w/out munging the source so we don't have
# to depend on texinfo to regen things.  #464146 (among others)
slot_info_pages() {
	pushd "${ED%/}"/usr/share/info >/dev/null || die
	rm -f dir || die

	# Rewrite all the references to other pages.
	# before: * aclocal-invocation: (automake)aclocal Invocation.   Generating aclocal.m4.
	# after:  * aclocal-invocation v1.13: (automake-1.13)aclocal Invocation.   Generating aclocal.m4.
	local p pages=( *.info ) args=()
	for p in "${pages[@]/%.info}" ; do
		args+=(
			-e "/START-INFO-DIR-ENTRY/,/END-INFO-DIR-ENTRY/s|: (${p})| v${SLOT}&|"
			-e "s:(${p}):(${p}-${SLOT}):g"
		)
	done
	sed -i "${args[@]}" * || die

	# Rewrite all the file references, and rename them in the process.
	local f d
	for f in * ; do
		d=${f/.info/-${SLOT}.info}
		mv "${f}" "${d}" || die
		sed -i -e "s:${f}:${d}:g" * || die
	done

	popd >/dev/null || die
}

src_test() {
	unset HELP2MAN # 583108

	default
}

src_install() {
	default
	slot_info_pages

	rm \
		"${ED%/}"/usr/bin/{aclocal,automake} \
		"${ED%/}"/usr/share/man/man1/{aclocal,automake}.1 || die

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	local x
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} /usr/share/${PN}-${SLOT}/config.${x}
	done
}
