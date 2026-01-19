# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/fche.asc
inherit autotools flag-o-matic linux-info python-single-r1 toolchain-funcs

DESCRIPTION="Linux trace/probe tool"
HOMEPAGE="https://sourceware.org/systemtap/ https://sourceware.org/systemtap/wiki"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://sourceware.org/git/systemtap.git"
	inherit git-r3
else
	inherit verify-sig
	SRC_URI="
		https://sourceware.org/ftp/${PN}/releases/${P}.tar.gz
		verify-sig? ( https://sourceware.org/ftp/${PN}/releases/${P}.tar.gz.asc )
	"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-fche )"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debuginfod dtrace-symlink libvirt selinux sqlite +ssl test zeroconf"

CDEPEND="
	${PYTHON_DEPS}

	dev-libs/boost:=
	>=dev-libs/elfutils-0.142[debuginfod?]
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
	app-alternatives/cpio
	app-text/xmlto
	>=sys-devel/gettext-0.18.2

	libvirt? ( dev-libs/libxml2:= )
"
RDEPEND="
	${CDEPEND}
	acct-group/stapdev
	acct-group/stapsys
	acct-group/stapusr
"
# which: https://sourceware.org/PR32106
BDEPEND+="
	$(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
	test? (
		dev-util/dejagnu
		|| (
			net-analyzer/netcat
			net-analyzer/openbsd-netcat
		)
		sys-apps/which
	)
"

CONFIG_CHECK="~KPROBES ~RELAY ~DEBUG_FS"
ERROR_KPROBES="${PN} requires support for KProbes Instrumentation (KPROBES) - this can be enabled in 'Instrumentation Support -> Kprobes'."
ERROR_RELAY="${PN} works with support for user space relay support (RELAY) - this can be enabled in 'General setup -> Kernel->user space relay support (formerly relayfs)'."
ERROR_DEBUG_FS="${PN} works best with support for Debug Filesystem (DEBUG_FS) - this can be enabled in 'Kernel hacking -> Debug Filesystem'."

DOCS="AUTHORS HACKING NEWS README"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# bug #935333, bug #923597, and so on; needs work to get passing on Gentoo.
RESTRICT="!test? ( test ) test"
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
		-e 's#$(INSTALL_DATA) $(srcdir)/stap-exporter.options "$(DESTDIR)$(sysconfdir)/sysconfig/stap-exporter"##g' \
		stap-exporter/Makefile.am || die "Failed to modify stap-exporter Makefile.am"
	sed -i \
		-e '\#^EnvironmentFile=-/etc/sysconfig/stap-exporter#d' \
		-e 's#$PORT $KEEPALIVE $SCRIPTS $OPTIONS#--port 9900 --keepalive 300#g' \
		stap-exporter/stap-exporter.service || die "Failed to adapt stap-exporter.service"

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--cache-file="${S}"/config.cache
		--disable-docs
		--disable-grapher
		--disable-refdocs
		--disable-server
		--disable-Werror
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
		$(use_with debuginfod)
		$(use_with zeroconf avahi)
		$(use_with ssl nss)
		$(use_with selinux)
	)

	# Use bash because of bashisms with brace expansion in Makefile.am
	# https://sourceware.org/PR32105
	CONFIG_SHELL="${BROOT}"/bin/bash PYTHON3="${PYTHON}" econf "${myeconfargs[@]}"
}

src_test() {
	# TODO: Install tests like dev-debug/dtrace[test-install] and
	# e.g. Fedora does.
	(
		strip-flags
		filter-flags '-fcf-protection=*'
		filter-flags '-fdiagnostics-color=*' '-fdiagnostics-urls=*'
		filter-flags '-g*'
		filter-lto
		tc-ld-force-bfd
		emake -Onone -k check CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
	)
}

src_install() {
	default
	rm -rf "${D}/$(python_get_sitedir)"/*.egg-info || die
	python_optimize

	# Avoid file collision with dev-debug/dtrace
	mv "${ED}"/usr/bin/dtrace "${ED}"/usr/bin/stap-dtrace || die

	if use dtrace-symlink ; then
		dosym stap-dtrace /usr/bin/dtrace
	fi
}
