# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="An OCI container runtime monitor"
HOMEPAGE="https://github.com/containers/conmon"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/conmon.git"
else
	SRC_URI="https://github.com/containers/conmon/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
	GIT_COMMIT="00e08f4a9ca5420de733bf542b930ad58e1a7e7d"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+seccomp systemd"
RESTRICT="test"

RDEPEND="dev-libs/glib:=
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd:= )"
DEPEND="${RDEPEND}"
BDEPEND="dev-go/go-md2man"
PATCHES=(
	"${FILESDIR}/conmon-2.1.8-Makefile.patch"
)

src_prepare() {
	default
	if use systemd; then
		sed -i -e 's|shell $(PKG_CONFIG) --exists libsystemd.* && echo "0"|shell echo "0"|g;' Makefile || die
	else
		sed -i -e 's|shell $(PKG_CONFIG) --exists libsystemd.* && echo "0"|shell echo "1"|g;' Makefile || die
	fi

	if use seccomp; then
		echo -e '#!/usr/bin/env bash\necho "0"' > hack/seccomp-notify.sh || die
	else
		echo -e '#!/usr/bin/env bash\necho "1"' > hack/seccomp-notify.sh || die
	fi
}

src_compile() {
	tc-export CC PKG_CONFIG
	export PREFIX=${EPREFIX}/usr GOMD2MAN=go-md2man
	if [[ ${PV} == *9999* ]]; then
		default
	else
		emake GIT_COMMIT="${GIT_COMMIT}"
	fi
}

src_install() {
	default
	dodir /usr/libexec/podman
	dosym ../../bin/"${PN}" /usr/libexec/podman/conmon
}
