# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit autotools linux-info python-single-r1

DESCRIPTION="A linux trace/probe tool"
HOMEPAGE="https://www.sourceware.org/systemtap"
SRC_URI="https://www.sourceware.org/${PN}/ftp/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="libvirt selinux sqlite +ssl test zeroconf"

CDEPEND="
	${PYTHON_DEPS}

	dev-libs/boost:=
	>=dev-libs/elfutils-0.142
	dev-libs/json-c:=
	sys-libs/ncurses:=
	sys-libs/readline:=

	libvirt? ( >=app-emulation/libvirt-1.0.2 )
	selinux? ( sys-libs/libselinux )
	sqlite? ( dev-db/sqlite:3 )
	ssl? (
		dev-libs/nspr
		dev-libs/nss
	)
	zeroconf? ( net-dns/avahi )
"
DEPEND="
	${CDEPEND}
	app-arch/cpio
	app-text/xmlto
	$(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
	>=sys-devel/gettext-0.18.2

	libvirt? ( dev-libs/libxml2 )
"
RDEPEND="
	${CDEPEND}
	acct-group/stapdev
	acct-group/stapsys
	acct-group/stapusr
"
BDEPEND="test? ( dev-util/dejagnu )"

CONFIG_CHECK="~KPROBES ~RELAY ~DEBUG_FS"
ERROR_KPROBES="${PN} requires support for KProbes Instrumentation (KPROBES) - this can be enabled in 'Instrumentation Support -> Kprobes'."
ERROR_RELAY="${PN} works with support for user space relay support (RELAY) - this can be enabled in 'General setup -> Kernel->user space relay support (formerly relayfs)'."
ERROR_DEBUG_FS="${PN} works best with support for Debug Filesystem (DEBUG_FS) - this can be enabled in 'Kernel hacking -> Debug Filesystem'."

DOCS="AUTHORS HACKING NEWS README"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"
PATCHES=(
	"${FILESDIR}/${PN}-3.1-ia64.patch"
)

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .

	sed -i \
		-e 's|-Werror||g' \
		configure.ac \
		Makefile.am \
		stapbpf/Makefile.am \
		stapdyn/Makefile.am \
		staprun/Makefile.am \
		testsuite/systemtap.unprivileged/unprivileged_probes.exp \
		testsuite/systemtap.unprivileged/unprivileged_myproc.exp \
		testsuite/systemtap.base/stmt_rel_user.exp \
		testsuite/systemtap.base/sdt_va_args.exp \
		testsuite/systemtap.base/sdt_misc.exp \
		testsuite/systemtap.base/sdt.exp \
		scripts/kprobes_test/gen_code.py \
		|| die "Failed to clean up sources"

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-docs
		--disable-grapher
		--disable-refdocs
		--disable-server
		# Our toolchain sets this for us already and adding in
		# -D_FORTIFY_SOURCE=2 breaks builds w/ no optimisation.
		# This option (at least as of 4.5) doesn't pass -fno* etc,
		# it just doesn't _add_ options, which is good. If it changes
		# to actually pass -fno-stack-protector and friends, we'll
		# need to change course. Forcing =2 also has problems for
		# setting it to 3.
		# bug #794667.
		--disable-ssp
		--enable-pie
		--with-python3
		--without-java
		--without-openssl
		--without-python2-probes
		--without-rpm
		$(use_enable libvirt virt)
		$(use_enable sqlite)
		$(use_with zeroconf avahi)
		$(use_with ssl nss)
		$(use_with selinux)
	)
	PYTHON3="${PYTHON}" econf "${myeconfargs[@]}"
}

src_install() {
	default
	python_optimize
}
