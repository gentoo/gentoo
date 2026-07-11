# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="An OCI container runtime monitor"
HOMEPAGE="https://github.com/containers/conmon"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/conmon.git"
else
	SRC_URI="https://github.com/containers/conmon/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+seccomp selinux systemd"
RESTRICT="test"

DEPEND="
	dev-libs/glib:=
	seccomp? ( sys-libs/libseccomp )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-podman )
"
BDEPEND="dev-go/go-md2man"

src_prepare() {
	default
	sed -i \
		-e "s|shell.*--exists libsystemd.* && echo \"0\"|shell echo $(usex systemd 0 1)|g;" \
		-e "s|install.bin: bin/conmon|install.bin:|g;" \
		-e "s|install: install.bin docs|install: install.bin|g;" Makefile || die
	echo -e "#!/usr/bin/env bash\necho $(usex seccomp 0 1)" > hack/seccomp-notify.sh || die
}

src_compile() {
	tc-export CC PKG_CONFIG
	export PREFIX="${EPREFIX}/usr" GOMD2MAN=$(command -v go-md2man)
	[[ "${PV}" == 9999* ]] && { local ADD_GIT_INFO=git-vars || die ; }
	emake "${ADD_GIT_INFO}" bin bin/conmon docs
}

src_install() {
	default
	dosym -r /usr/bin/"${PN}" /usr/libexec/crio/"${PN}"
	dosym -r /usr/bin/"${PN}" /usr/libexec/podman/"${PN}"
}
