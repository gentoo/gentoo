# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-any-r1 scons-utils toolchain-funcs flag-o-matic

DESCRIPTION="Synchronous multi-master replication engine that provides the wsrep API"
HOMEPAGE="https://galeracluster.com"
SRC_URI="https://releases.galeracluster.com/galera-4/source/galera-4-${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2 BSD"

SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 x86"
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

# Respect {C,LD}FLAGS.
PATCHES=(
	"${FILESDIR}"/${PN}-26.4.6-strip-extra-cflags.patch
	"${FILESDIR}"/${PN}-26.4.5-respect-toolchain.patch
)

S="${WORKDIR}/galera-4-${PV}"

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
	tc-export AR CC CXX OBJDUMP

	# strict_build_flags=0 disables -Werror, -pedantic, -Weffc++,
	# and -Wold-style-cast
	MYSCONS=(
		crc32c_no_hardware=$(usex cpu_flags_x86_sse4_2 0 1)
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
		newinitd "${FILESDIR}/garb.init" garbd
		doman man/garbd.8
	fi
	exeinto /usr/$(get_libdir)/${PN}
	doexe libgalera_smm.so
}
