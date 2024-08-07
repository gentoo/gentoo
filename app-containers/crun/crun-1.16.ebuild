# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit python-any-r1

DESCRIPTION="A fast and low-memory footprint OCI Container Runtime fully written in C"
HOMEPAGE="https://github.com/containers/crun"

if [[ "$PV" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/${PN}.git"
else
	SRC_URI="https://github.com/containers/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
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

src_configure() {
	local myeconfargs=(
		$(use_enable bpf)
		$(use_enable caps)
		$(use_enable criu)
		$(use_enable seccomp)
		$(use_enable systemd)
		$(usex static-libs '--enable-shared --enable-static' '--enable-shared --disable-static' '' '')
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake "DESTDIR=${D}" install-exec
	doman crun.1
	einstalldocs

	einfo "Cleaning up .la files"
	find "${ED}" -name '*.la' -delete || die
}
