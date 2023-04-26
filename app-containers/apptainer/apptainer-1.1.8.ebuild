# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info toolchain-funcs

DESCRIPTION="The container system for secure high-performance computing"
HOMEPAGE="https://apptainer.org/"
SRC_URI="https://github.com/apptainer/${PN}/releases/download/v${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="examples +network suid systemd"

# Do not complain about CFLAGS etc. since go projects do not use them.
QA_FLAGS_IGNORED='.*'

DEPEND="app-crypt/gpgme
	>=dev-lang/go-1.17.6
	dev-libs/openssl
	sys-apps/util-linux
	sys-fs/cryptsetup
	sys-fs/squashfs-tools
	sys-libs/libseccomp
	!suid? (
		sys-fs/e2fsprogs[fuse]
		sys-fs/squashfuse
	)"
RDEPEND="${DEPEND}
	!sys-cluster/singularity"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~SQUASHFS"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2-trim_upstream_cflags.patch
)

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
		$(use_with suid)
	)
	./mconfig -v ${myconfargs[@]} || die "Error invoking mconfig"
}

src_compile() {
	emake -C builddir
}

src_install() {
	emake DESTDIR="${D}" -C builddir install
	keepdir /var/${PN}/mnt/session

	if use systemd; then
		sed -i -e '/systemd cgroups/ s/no/yes/' "${ED}"/etc/${PN}/${PN}.conf \
			|| die "Failed to enable systemd use in configuration"
	else
		sed -i -e '/systemd cgroups/ s/yes/no/' "${ED}"/etc/${PN}/${PN}.conf \
			|| die "Failed to disable systemd use in configuration"
	fi

	einstalldocs
	if use examples; then
		dodoc -r examples
	fi
}

pkg_postinst() {
	if ! use suid; then
		local oldver
		for oldver in ${REPLACING_VERSIONS}; do
			if ver_test "${oldver}" -lt 1.1.0; then
				ewarn "Since version 1.1.0 ${PN} no longer installs setuid-root components by default, relying on unprivileged user namespaces instead. For details, see https://apptainer.org/docs/admin/main/user_namespace.html"
				ewarn "Make sure user namespaces (possibly except network ones for improved security) are enabled on your system, or re-enable installation of setuid root components by passing USE=suid to ${CATEGORY}/${PN}"
				break
			fi
		done
	fi
}
