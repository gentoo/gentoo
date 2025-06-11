# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic linux-info pam systemd

DESCRIPTION="Tools and libraries to configure and manage kernel control groups"
HOMEPAGE="https://github.com/libcgroup/libcgroup"
SRC_URI="https://github.com/libcgroup/libcgroup/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+daemon pam static-libs systemd test +tools"
REQUIRED_USE="daemon? ( tools )"
RESTRICT="!test? ( test ) "

DEPEND="
	elibc_musl? ( sys-libs/fts-standalone )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.0-use-system-gtest.patch
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
	find src -name '*.c' -o -name '*.h' -print0 \
		| xargs -0 sed -i '/^#define/s:/etc/cg:/etc/cgroup/cg:'
	sed -i 's:/etc/cg:/etc/cgroup/cg:' \
		doc/man/cg* samples/config/*.conf README* || die "sed failed"

	eautoreconf
}

src_configure() {
	if use elibc_musl; then
		append-ldflags -lfts
	fi

	# gtest needs >=C++14, just pick gnu++17
	append-cxxflags -std=gnu++17

	# Test failures (bug #956346)
	filter-lto

	# Needs flex+bison
	unset LEX YACC

	local myconf=(
		--disable-python
		$(use_enable static-libs static)
		$(use_enable daemon)
		$(use_enable pam)
		$(use_enable systemd)
		$(use_enable tools)
		$(use_enable test tests)
		$(use_enable test unittests)
	)

	if use pam; then
		myconf+=( "--enable-pam-module-dir=$(getpam_mod_dir)" )
	fi

	econf "${myconf[@]}"
}

src_test() {
	# Sandboxes confuse this as it expects specific cgroup layout
	local -x GTEST_FILTER="-CgroupProcessV1MntTest.AddV1NamedMount"

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
	doins samples/config/cgsnapshot_denylist.conf

	keepdir /etc/cgroup/cgconfig.d
	keepdir /etc/cgroup/cgrules.d

	if use tools; then
		newconfd "${FILESDIR}/cgconfig.confd-r2" cgconfig
		newinitd "${FILESDIR}/cgconfig.initd-r2" cgconfig
		systemd_dounit "${FILESDIR}/cgconfig.service"
		systemd_dounit "${FILESDIR}/cgrules.service"
	fi

	if use daemon; then
		newconfd "${FILESDIR}/cgred.confd-r2" cgred
		newinitd "${FILESDIR}/cgred.initd-r1" cgred
	fi
}
