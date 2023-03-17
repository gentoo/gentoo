# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic linux-info pam systemd

DESCRIPTION="Tools and libraries to configure and manage kernel control groups"
HOMEPAGE="https://github.com/libcgroup/libcgroup"
SRC_URI="https://github.com/libcgroup/libcgroup/releases/download/v$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+daemon pam static-libs test +tools"
REQUIRED_USE="daemon? ( tools )"

# Test failure needs investigation
RESTRICT="!test? ( test ) test"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
"
DEPEND="
	elibc_musl? ( sys-libs/fts-standalone )
	pam? ( sys-libs/pam )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0-configure-bashism.patch
	"${FILESDIR}"/${PN}-3.0.0-musl-strerror_r.patch
)

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS"
	if use daemon; then
		CONFIG_CHECK="${CONFIG_CHECK} ~CONNECTOR ~PROC_EVENTS"
	fi
	linux-info_pkg_setup
}

src_prepare() {
	default

	# Change rules file location
	find src -name *.c -o -name *.h \
		| xargs sed -i '/^#define/s:/etc/cg:/etc/cgroup/cg:'
	sed -i 's:/etc/cg:/etc/cgroup/cg:' \
		doc/man/cg* samples/config/*.conf README* || die "sed failed"

	# Drop native libcgconfig init config
	sed -i '/^man_MANS/s:cgred.conf.5::' \
		doc/man/Makefile.am || die "sed failed"

	# If we're not running tests, don't bother building them.
	if ! use test; then
		sed -i '/^SUBDIRS/s:tests::' Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	use elibc_musl && append-ldflags -lfts

	local my_conf=(
		$(use_enable static-libs static)
		$(use_enable daemon)
		$(use_enable pam)
		$(use_enable tools)
		$(use_enable test tests)
	)

	if use pam; then
		my_conf+=( --enable-pam-module-dir="$(getpam_mod_dir)" )
	fi

	econf "${my_conf[@]}"
}

src_test() {
	# Run just the unit tests rather than the full lot as they
	# need fewer permissions, no containers, etc.
	emake -C tests/gunit check
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	insinto /etc/cgroup
	doins samples/config/cgconfig.conf
	doins samples/config/cgrules.conf
	doins samples/config/cgsnapshot_blacklist.conf

	keepdir /etc/cgroup/cgconfig.d
	keepdir /etc/cgroup/cgrules.d

	if use tools; then
		newconfd "${FILESDIR}"/cgconfig.confd-r1 cgconfig
		newinitd "${FILESDIR}"/cgconfig.initd-r1 cgconfig
		systemd_dounit "${FILESDIR}"/cgconfig.service
		systemd_dounit "${FILESDIR}"/cgrules.service
	fi

	if use daemon; then
		newconfd "${FILESDIR}"/cgred.confd-r2 cgred
		newinitd "${FILESDIR}"/cgred.initd-r1 cgred
	fi
}
