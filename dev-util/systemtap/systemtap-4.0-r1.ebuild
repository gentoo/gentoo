# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit linux-info autotools python-single-r1 user

DESCRIPTION="A linux trace/probe tool"
HOMEPAGE="https://www.sourceware.org/systemtap/"
SRC_URI="https://www.sourceware.org/${PN}/ftp/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="libvirt selinux sqlite +ssl zeroconf"

RDEPEND=">=dev-libs/elfutils-0.142
	dev-libs/json-c:=
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	${PYTHON_DEPS}
	libvirt? ( >=app-emulation/libvirt-1.0.2 )
	selinux? ( sys-libs/libselinux )
	sqlite? ( dev-db/sqlite:3 )
	ssl? (
		dev-libs/nspr
		dev-libs/nss
	)
	zeroconf? ( net-dns/avahi )
"
DEPEND="${RDEPEND}
	app-arch/cpio
	app-text/xmlto
	>=sys-devel/gettext-0.18.2
	libvirt? ( dev-libs/libxml2 )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CONFIG_CHECK="~KPROBES ~RELAY ~DEBUG_FS"
ERROR_KPROBES="${PN} requires support for KProbes Instrumentation (KPROBES) - this can be enabled in 'Instrumentation Support -> Kprobes'."
ERROR_RELAY="${PN} works with support for user space relay support (RELAY) - this can be enabled in 'General setup -> Kernel->user space relay support (formerly relayfs)'."
ERROR_DEBUG_FS="${PN} works best with support for Debug Filesystem (DEBUG_FS) - this can be enabled in 'Kernel hacking -> Debug Filesystem'."

DOCS="AUTHORS HACKING NEWS README"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1-ia64.patch
)

pkg_setup() {
	enewgroup stapusr 156
	enewgroup stapsys 157
	enewgroup stapdev 158

	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	python_fix_shebang .

	sed -i \
		-e 's:-Werror::g' \
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
	PYTHON3="${PYTHON}" \
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	python_optimize
}
