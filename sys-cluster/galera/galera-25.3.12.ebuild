# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="${PN}-3-${PV}"

inherit scons-utils multilib toolchain-funcs eutils user flag-o-matic
DESCRIPTION="Synchronous multi-master replication engine that provides the wsrep API"
HOMEPAGE="http://www.galeracluster.com"
SRC_URI="http://releases.galeracluster.com/source/galera-3-${PV}.tar.gz"
LICENSE="GPL-2 BSD"

SLOT="0"

KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="cpu_flags_x86_sse4_2 garbd ssl test"

CDEPEND="
	 ssl? ( dev-libs/openssl:0= )
	>=dev-libs/boost-1.41:0=
	"
DEPEND="${DEPEND}
	${CDEPEND}
	dev-libs/check
	>=sys-devel/gcc-4.4
	>=dev-cpp/asio-1.4.8[ssl?]
	"
#Run time only
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_preinst() {
	if use garbd ; then
		enewgroup garbd
		enewuser garbd -1 -1 -1 garbd
	fi
}

src_prepare() {
	# Remove bundled dev-cpp/asio
	rm -r "${S}/asio" || die

	# Respect {C,LD}FLAGS.
	epatch "${FILESDIR}/respect-flags.patch" \
		"${FILESDIR}/galera-3.12-strip-machine-cflags.patch" \
		"${FILESDIR}/galera-3.12-strip-extra-buildconfig.patch"

	#Remove optional garbd daemon
	if ! use garbd ; then
		rm -r "${S}/garb" || die
	fi

	epatch_user
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
	myesconsargs=(
		$(use_scons ssl ssl 1 0)
		$(use_scons test tests 1 0)
		strict_build_flags=0
	)
}

src_compile() {
	escons --warn=no-missing-sconscript
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
