# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info toolchain-funcs

DESCRIPTION="The container system for secure high-performance computing"
HOMEPAGE="https://apptainer.org/"
SRC_URI="https://github.com/apptainer/${PN}/releases/download/v${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="examples +network +suid"

# Do not complain about CFLAGS etc. since go projects do not use them.
QA_FLAGS_IGNORED='.*'

DEPEND="app-crypt/gpgme
	>=dev-lang/go-1.17.6
	dev-libs/openssl
	sys-apps/util-linux
	sys-fs/cryptsetup
	sys-fs/squashfs-tools
	sys-libs/libseccomp"
RDEPEND="${DEPEND}
	!sys-cluster/singularity"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~SQUASHFS"

DOCS=( README.md CONTRIBUTORS.md CONTRIBUTING.md )

src_configure() {
	local myconfargs=(
		-c "$(tc-getBUILD_CC)" \
		-x "$(tc-getBUILD_CXX)" \
		-C "$(tc-getCC)" \
		-X "$(tc-getCXX)" \
		--prefix="${EPREFIX}"/usr \
		--sysconfdir="${EPREFIX}"/etc \
		--runstatedir="${EPREFIX}"/run \
		--localstatedir="${EPREFIX}"/var \
		$(usex network "" "--without-network") \
		$(usex suid "" "--without-suid")
	)
	./mconfig -v ${myconfargs[@]} || die "Error invoking mconfig"
}

src_compile() {
	emake -C builddir
}

src_install() {
	emake DESTDIR="${D}" -C builddir install
	keepdir /var/${PN}/mnt/session

	einstalldocs
	if use examples; then
		dodoc -r examples
	fi
}
