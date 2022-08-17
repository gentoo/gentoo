# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

# Can drop autotools/eautoreconf after next release & glibc patch gone
inherit autotools python-any-r1

DESCRIPTION="A fast and low-memory footprint OCI Container Runtime fully written in C"
HOMEPAGE="https://github.com/containers/crun"
SRC_URI="https://github.com/containers/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
IUSE="+bpf +caps criu +seccomp selinux systemd static-libs"

DEPEND="
	dev-libs/yajl:=
	sys-kernel/linux-headers
	caps? ( sys-libs/libcap )
	criu? ( >=sys-process/criu-3.15 )
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-container )"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
"

# the crun test suite is comprehensive to the extent that tests will fail
# within a sandbox environment, due to the nature of the privileges
# required to create linux "containers".
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.5-glibc-2.36.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable bpf)
		$(use_enable caps)
		$(use_enable criu)
		$(use_enable seccomp)
		$(use_enable systemd)
		$(usex static-libs '--enable-shared --enable-static' '--enable-shared --disable-static' '' '')
	)

	# Need https://github.com/containers/libocispec/pull/107 to be merged & land in
	# a crun release that syncs up w/ latest version, then can drop CONFIG_SHELL
	CONFIG_SHELL="${BROOT}/bin/bash" econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C libocispec
	emake crun
}

src_install() {
	emake "DESTDIR=${D}" install-exec
	doman crun.1
	einstalldocs
}
