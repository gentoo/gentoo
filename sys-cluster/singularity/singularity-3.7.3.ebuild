# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info toolchain-funcs

DESCRIPTION="Application containers for Linux"
HOMEPAGE="https://sylabs.io"
SRC_URI="https://github.com/hpcng/${PN}/releases/download/v${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples +network +suid"

# Do not complain about CFLAGS etc. since go projects do not use them.
QA_FLAGS_IGNORED='.*'

COMMON="sys-libs/libseccomp"
BDEPEND="virtual/pkgconfig"
DEPEND="${COMMON}
	>=dev-lang/go-1.13.0
	app-crypt/gpgme
	dev-libs/openssl
	sys-apps/util-linux
	sys-fs/cryptsetup"
RDEPEND="${COMMON}
	sys-fs/squashfs-tools"

CONFIG_CHECK="~SQUASHFS"

S=${WORKDIR}/${PN}

src_configure() {
	local myconfargs=(
		-c "$(tc-getBUILD_CC)" \
		-x "$(tc-getBUILD_CXX)" \
		-C "$(tc-getCC)" \
		-X "$(tc-getCXX)" \
		--prefix=/usr \
		--sysconfdir=/etc \
		--runstatedir=/run \
		--localstatedir=/var \
		$(usex network "" "--without-network") \
		$(usex suid "" "--without-suid")
	)
	./mconfig -v ${myconfargs[@]} || die "Error invoking mconfig"
}

src_compile() {
	emake -C builddir
}

src_install() {
	emake DESTDIR="${ED}" -C builddir install
	keepdir /var/singularity/mnt/session

	# As of version 3.5.3 this seems to be very much broken, affecting
	# commands which have got nothing to do with singularity (example:
	# completion on 'udisks mount -b /dev/' rejects all files from that
	# directory other than 'autofs'). Moreover, this should go into
	# $(get_bashcompdir) (from bash-completion-r1.eclass) rather than /etc.
	# Hopefully temporary, which is why we delete this at install time
	# instead of patching build scripts not to generate bash-completion
	# data in the first place.
	rm -rf "${ED}"/etc/bash_completion.d || die

	dodoc README.md CONTRIBUTORS.md CONTRIBUTING.md
	if use examples; then
		dodoc -r examples
	fi
}
