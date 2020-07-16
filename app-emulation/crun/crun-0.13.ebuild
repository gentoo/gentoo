# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit autotools python-any-r1

DESCRIPTION="A fast and low-memory footprint OCI Container Runtime fully written in C"
HOMEPAGE="https://github.com/containers/crun"
SRC_URI="https://github.com/containers/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bpf +caps doc seccomp systemd static-libs"

DEPEND="
	dev-libs/yajl
	caps? ( sys-libs/libcap )
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	doc? ( dev-go/go-md2man )
"

# the crun test suite is comprehensive to the extent that tests will fail
# within a sandbox environment, due to the nature of the privileges
# required to create linux "containers".
RESTRICT="test"

DOCS=( README.md )

PATCHES=(
	# see https://709982.bugs.gentoo.org/attachment.cgi?id=614208
	"${FILESDIR}/libocispec-deduplicate-json_common-in-makefile-am.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-criu \
		$(use_enable bpf) \
		$(use_enable caps) \
		$(use_enable seccomp) \
		$(use_enable systemd) \
		$(usex static-libs '--enabled-shared  --enabled-static' '--enable-shared --disable-static' '' '')
}

src_compile() {
	emake -C libocispec
	emake crun
	if use doc ; then
		emake generate-man
	fi
}

src_install() {
	emake "DESTDIR=${D}" install-exec
	if use doc ; then
		emake "DESTDIR=${D}" install-man
	fi

	einstalldocs
}
