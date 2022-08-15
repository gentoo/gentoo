# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit python-any-r1

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/r/${PN}.git"
	inherit git-r3
else
	if [[ ${PV/_beta} == ${PV} ]]; then
		MY_P="${P}"
		SRC_URI="mirror://gnu/${PN}/${P}.tar.xz
			https://alpha.gnu.org/pub/gnu/${PN}/${MY_P}.tar.xz"
		KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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

RDEPEND="dev-lang/perl
	>=sys-devel/automake-wrapper-11
	>=sys-devel/autoconf-2.69:*
	sys-devel/gnuconfig"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/gzip
	sys-apps/help2man
	test? ( ${PYTHON_DEPS} )
"

PATCHES=(
	"${FILESDIR}"/automake-1.16.2-py3-compile.patch
	"${FILESDIR}"/automake-1.16.2-fix-instmany-python.sh-test.patch
	"${FILESDIR}"/automake-1.16.2-fix-py-compile-basedir.sh-test.patch
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
	default
}

# Slot the info pages. Do this w/out munging the source so we don't have
# to depend on texinfo to regen things. bug #464146 (among others)
slot_info_pages() {
	pushd "${ED}"/usr/share/info >/dev/null || die
	rm -f dir

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

src_install() {
	default

	slot_info_pages
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
}
