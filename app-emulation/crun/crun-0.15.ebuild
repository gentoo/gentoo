# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit autotools python-any-r1

DESCRIPTION="A fast and low-memory footprint OCI Container Runtime fully written in C"
HOMEPAGE="https://github.com/containers/crun"
SRC_URI="https://github.com/containers/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
IUSE="+bpf +caps criu man +seccomp systemd static-libs"

DEPEND="
	sys-kernel/linux-headers
	>=dev-libs/yajl-2.0.0
	caps? ( sys-libs/libcap )
	criu? ( >=sys-process/criu-3.13 )
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	man? ( dev-go/go-md2man )
"

# the crun test suite is comprehensive to the extent that tests will fail
# within a sandbox environment, due to the nature of the privileges
# required to create linux "containers".
RESTRICT="test"

DOCS=( README.md )

src_configure() {
	local myeconfargs=(
		$(use_enable bpf) \
		$(use_enable caps) \
		$(use_enable criu) \
		$(use_enable seccomp) \
		$(use_enable systemd) \
		$(usex static-libs '--enabled-shared  --enabled-static' '--enable-shared --disable-static' '' '')
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C libocispec
	emake crun
	if use man ; then
		emake generate-man
	fi
}

src_install() {
	emake "DESTDIR=${D}" install-exec
	if use man ; then
		emake "DESTDIR=${D}" install-man
	fi

	einstalldocs
}
