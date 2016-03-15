# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_P="${PN}-3-${PV}"

inherit scons-utils toolchain-funcs user flag-o-matic
DESCRIPTION="Synchronous multi-master replication engine that provides the wsrep API"
HOMEPAGE="http://www.galeracluster.com"
SRC_URI="http://releases.galeracluster.com/source/galera-3-${PV}.tar.gz"
LICENSE="GPL-2 BSD"

SLOT="0"

KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="cpu_flags_x86_sse4_2 garbd test"

CDEPEND="
	dev-libs/openssl:0=
	>=dev-libs/boost-1.41:0=
	"
DEPEND="${DEPEND}
	${CDEPEND}
	dev-libs/check
	>=sys-devel/gcc-4.4
	>=dev-cpp/asio-1.10.1[ssl]
	"
#Run time only
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}"
# Respect {C,LD}FLAGS.
PATCHES=( "${FILESDIR}/galera-3.13-strip-extra-cflags.patch" )

pkg_preinst() {
	if use garbd ; then
		enewgroup garbd
		enewuser garbd -1 -1 -1 garbd
	fi
}

src_prepare() {
	default

	# Remove bundled dev-cpp/asio
	rm -r "${S}/asio" || die

	#Remove optional garbd daemon
	if ! use garbd ; then
		rm -r "${S}/garb" || die
	fi
}

src_configure() {
	tc-export CC CXX
	# Uses hardware specific code that seems to depend on SSE4.2
	if use cpu_flags_x86_sse4_2 ; then
		append-cflags -msse4.2
	else
		append-cflags -DCRC32C_NO_HARDWARE
	fi
	# strict_build_flags=0 disables -Werror, -pedantic, -Weffc++,
	# and -Wold-style-cast
	MYSCONS=(
		ssl=1
		tests=$(usex test 1 0)
		strict_build_flags=0
	)
}

src_compile() {
	escons --warn=no-missing-sconscript "${MYSCONS[@]}"
}

src_install() {
	dodoc scripts/packages/README scripts/packages/README-MySQL
	if use garbd ; then
		dobin garb/garbd
		newconfd "${FILESDIR}/garb.cnf" garbd
		newinitd "${FILESDIR}/garb.sh" garbd
		doman man/garbd.8
	fi
	exeinto /usr/$(get_libdir)/${PN}
	doexe libgalera_smm.so
}
