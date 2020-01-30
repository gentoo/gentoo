# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}v$(ver_rs 1 '' 2 '-')" # 'a.b.c' -> 'ab-c'
DESCRIPTION="a simulator for historical computers such as Vax, PDP-11 etc.)"
HOMEPAGE="http://simh.trailing-edge.com/"
SRC_URI="http://simh.trailing-edge.com/sources/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/sim

PATCHES=(
	"${FILESDIR}"/${PN}-3.11.0-respect-FLAGS.patch
	"${FILESDIR}"/${PN}-3.11.0-fix-mkdir-race.patch
	"${FILESDIR}"/${PN}-3.11.0-fcommon.patch
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
		newbin ${BINFILE} "simh-$(basename ${BINFILE})"
	done

	insinto /usr/share/simh
	doins VAX/*.bin

	dodoc *.txt */*.txt
}
