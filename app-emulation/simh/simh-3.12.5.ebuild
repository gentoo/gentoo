# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs

MY_PV="$(ver_cut 1)$(ver_cut 2)-$(ver_cut 3)"
DESCRIPTION="a simulator for historical computers such as Vax, PDP-11 etc."
HOMEPAGE="https://simh.trailing-edge.com/"
SRC_URI="https://simh.trailing-edge.com/sources/simhv${MY_PV}.zip -> ${P}.zip"
S="${WORKDIR}/sim"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${PN}-3.12.5-respect-FLAGS.patch"
	"${FILESDIR}/${PN}-3.12.5-incompatible-pointer-types.patch"
)

src_prepare() {
	default

	# fix linking on Darwin
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed -e 's/-lrt//g' \
			-i makefile || die
	fi
}

src_compile() {
	export GCC="$(tc-getCC)"
	export LDFLAGS_O="${LDFLAGS}"
	export CFLAGS_O="${CFLAGS}"

	local my_makeopts=""
	if tc-is-gcc && ver_test $(gcc-version) -lt 4.6 ; then
		my_makeopts+=" NO_LTO=1"
	fi

	emake ${my_makeopts}
}

src_install() {
	for BINFILE in BIN/* ; do
		[ -f "${BINFILE}" ] && newbin ${BINFILE} "simh-$(basename ${BINFILE})"
	done

	insinto /usr/share/simh
	doins VAX/*.bin

	dodoc doc/*.doc */*.txt
}
