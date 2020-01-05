# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

MY_P="${PN}-3-${PV}"

inherit python-any-r1 scons-utils toolchain-funcs user flag-o-matic
DESCRIPTION="Synchronous multi-master replication engine that provides the wsrep API"
HOMEPAGE="http://galeracluster.com"
SRC_URI="http://nyc2.mirrors.digitalocean.com/mariadb/mariadb-10.3.20/${P}/src/${P}.tar.gz"
LICENSE="GPL-2 BSD"

SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="cpu_flags_x86_sse4_2 garbd test"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-libs/openssl:0=
	>=dev-libs/boost-1.41:0=
	"
BDEPEND=">=sys-devel/gcc-4.4"
DEPEND="${BDEPEND}
	${CDEPEND}
	dev-libs/check
	>=dev-cpp/asio-1.10.1[ssl]
	<dev-cpp/asio-1.12.0
	"
#Run time only
RDEPEND="${CDEPEND}"

#S="${WORKDIR}/${MY_P}"
# Respect {C,LD}FLAGS.
PATCHES=( "${FILESDIR}/galera-4.1-strip-extra-cflags.patch" )

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
		tests=$(usex test 1 0)
		strict_build_flags=0
		system_asio=1
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
