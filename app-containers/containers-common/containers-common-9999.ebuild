# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

DESCRIPTION="Common config files and docs for Containers stack"
HOMEPAGE="https://github.com/containers/common"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/common.git"
else
	SRC_URI="https://github.com/containers/common/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P#containers-}"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"
RESTRICT="test"
RDEPEND="
	>=app-containers/aardvark-dns-1.10.0
	>=app-containers/crun-1.14.3
	>=app-containers/containers-image-5.30.0
	>=app-containers/containers-storage-1.53.0
	app-containers/containers-shortnames
	>=app-containers/netavark-1.10.3
	net-firewall/nftables
	net-firewall/iptables[nftables]
	>=net-misc/passt-2024.03.20
	>=sys-fs/fuse-overlayfs-1.13
"

BDEPEND="
	>=dev-go/go-md2man-2.0.3
"

PATCHES=(
	"${FILESDIR}/examplify-mounts-conf.patch"
)

DOC_CONTENTS="\n
For rootless operations, one needs to configure subuid(5) and subgid(5)\n
See /etc/sub{uid,gid} to check whether rootless user is already configured\n
If not, quickly configure it with:\n
usermod --add-subuids 1065536-1131071 <rootless user>\n
usermod --add-subgids 1065536-1131071 <rootless user>\n
"

src_prepare() {
	default

	[[ -f docs/Makefile && -f Makefile ]] || die
	sed -i -e 's|/usr/local|/usr|g;' docs/Makefile Makefile || die
}

src_compile() {
	emake docs
}

src_install() {
	emake DESTDIR="${ED}" install
	readme.gentoo_create_doc

	insinto /usr/share/containers
	doins pkg/seccomp/seccomp.json pkg/subscriptions/mounts.conf

	keepdir /etc/containers/certs.d /etc/containers/oci/hooks.d /etc/containers/systemd /var/lib/containers/sigstore
}

pkg_postinst() {
	readme.gentoo_print_elog
}
