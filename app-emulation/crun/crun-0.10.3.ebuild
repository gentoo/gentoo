# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="A fast and low-memory footprint OCI Container Runtime fully written in C"
HOMEPAGE="https://github.com/containers/crun"
SRC_URI="https://github.com/containers/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bpf +caps doc seccomp systemd static-libs"

DEPEND="
	dev-libs/yajl
	sys-libs/libseccomp
	caps? ( sys-libs/libcap )
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-lang/python-3.5.0
	doc? ( dev-go/go-md2man )
"

DOCS=( README.md )

src_configure() {
	econf \
		$(use_enable bpf) \
		$(use_enable caps) \
		$(use_enable seccomp) \
		$(use_enable systemd) \
		$(usex static-libs '--enabled-shared  --enabled-static' '--enable-shared --disable-static' '' '')
}

src_compile() {
	pushd libocispec || die
	emake
	popd
	emake crun
	if use doc ; then
		emake crun.1
	fi
}

src_install() {
	pushd libocispec || die
	emake "DESTDIR=$D" install-exec
	popd
	emake "DESTDIR=$D" install-exec
	if use doc ; then
		emake "DESTDIR=$D" install-man
	fi

	einstalldocs
}
