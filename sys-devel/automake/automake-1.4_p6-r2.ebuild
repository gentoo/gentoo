# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${P/_/-}"
DESCRIPTION="Used to generate Makefile.in from Makefile.am"
HOMEPAGE="https://www.gnu.org/software/automake/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
# Use Gentoo versioning for slotting.
SLOT="${PV:0:3}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE=""

RDEPEND="dev-lang/perl
	>=sys-devel/automake-wrapper-10
	>=sys-devel/autoconf-2.69:*
	sys-devel/gnuconfig"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-nls-nuisances.patch #121151
	"${FILESDIR}"/${PN}-1.4-libtoolize.patch
	"${FILESDIR}"/${PN}-1.4-subdirs-89656.patch
	"${FILESDIR}"/${PN}-1.4-ansi2knr-stdlib.patch
	"${FILESDIR}"/${PN}-1.4-CVE-2009-4029.patch #295357
	"${FILESDIR}"/${PN}-1.4-perl-5.11.patch
	"${FILESDIR}"/${PN}-1.4-perl-dyn-call.patch
)

src_prepare() {
	default
	export WANT_AUTOCONF=2.5
	sed -i 's:error\.test::' tests/Makefile.in #79529
}

# slot the info pages.  do this w/out munging the source so we don't have
# to depend on texinfo to regen things.  #464146 (among others)
slot_info_pages() {
	pushd "${ED}"/usr/share/info >/dev/null || die
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

src_install() {
	emake install DESTDIR="${D}" \
		pkgdatadir=/usr/share/automake-${SLOT} \
		m4datadir=/usr/share/aclocal-${SLOT}
	slot_info_pages
	rm -f "${ED}"/usr/bin/{aclocal,automake} || die
	dosym automake-${SLOT} /usr/share/automake

	dodoc NEWS README THANKS TODO AUTHORS ChangeLog

	# remove all config.guess and config.sub files replacing them
	# w/a symlink to a specific gnuconfig version
	local x
	for x in guess sub ; do
		dosym ../gnuconfig/config.${x} \
			/usr/share/${PN}-${SLOT}/config.${x}
	done
}
