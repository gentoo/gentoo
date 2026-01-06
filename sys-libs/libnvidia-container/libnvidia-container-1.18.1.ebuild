# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

# check the VERSION in libnvidia-container/mk/nvidia-modprobe.mk
NVMODV="550.54.14"

DESCRIPTION="NVIDIA container runtime library"
HOMEPAGE="https://github.com/NVIDIA/libnvidia-container"

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NVIDIA/${PN}.git"
else
	SRC_URI="
		https://github.com/NVIDIA/${PN}/archive/v${PV/_rc/-rc.}.tar.gz -> ${P}.tar.gz
	"
	S="${WORKDIR}/${PN}-${PV/_rc/-rc.}"
	KEYWORDS="~amd64"
fi
NVMODS="${WORKDIR}/nvidia-modprobe-${NVMODV}"
SRC_URI+="
	https://github.com/NVIDIA/nvidia-modprobe/archive/${NVMODV}.tar.gz -> ${PN}-nvidia-modprobe-${NVMODV}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
IUSE="+seccomp static-libs"

# libtirpc
# NOTE It seams that library also has optional support for net-libs/libtirpc, but I didn't
#      manage to build without it, probably the support for that build-roted away.
DEPEND="
	net-libs/libtirpc:=
	sys-libs/libcap
	virtual/libelf:=
	seccomp? ( sys-libs/libseccomp )
"

RDEPEND="${DEPEND}
	elibc_glibc? ( x11-drivers/nvidia-drivers )
"

BDEPEND="
	dev-lang/go
	net-libs/rpcsvc-proto
	sys-apps/lsb-release
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.17.0-fix-makefile-r1.patch"
)

DOCS=( NOTICE README.md )

src_unpack() {
	default_src_unpack
	if [[ "${PV}" == "9999" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	# nvidia-modprobe patching based on libnvidia-container/mk/nvidia-modprobe.mk
	mkdir -p "${S}"/deps/src/nvidia-modprobe-"${NVMODV}" || die
	cp -r "${NVMODS}"/modprobe-utils/ "${S}"/deps/src/nvidia-modprobe-"${NVMODV}"/ || die
	touch "${S}/deps/src/nvidia-modprobe-${NVMODV}/.download_stamp" || die
	pushd "${S}/deps/src/nvidia-modprobe-${NVMODV}" || die
	eapply -p1 "${S}"/mk/nvidia-modprobe.patch
	popd || die

	if ! tc-is-gcc; then
		ewarn "libnvidia-container must be built with gcc because of option \"-fplan9-extensions\"!"
		ewarn "Ignoring CC=$(tc-getCC) and forcing ${CHOST}-gcc"
		export CC=${CHOST}-gcc AR=${CHOST}-gcc-ar
		tc-is-gcc || die "tc-is-gcc failed in spite of CC=${CC}"
	fi

	default
}

src_configure() {
	export GOPATH="${S}"
	export GOFLAGS="-mod=vendor"
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	export CGO_CFLAGS="${CGO_CFLAGS:-$CFLAGS}"
	export CGO_LDFLAGS="${CGO_LDFLAGS:-$LDFLAGS}"

	tc-export LD OBJCOPY PKG_CONFIG

	# we could also set GO compiller, but it currently defaults to gccgo, but as for now I believe
	# most users will prefer dev-lang/go and they usually don't define GO="go" their make.conf either.
	# tc-export GO

	my_makeopts=(
		prefix="${EPREFIX}/usr"
		libdir="${EPREFIX}/usr/$(get_libdir)"
		GO_LDFLAGS="-compressdwarf=false -linkmode=external"
		WITH_SECCOMP="$(usex seccomp)"
	)
	# WITH_TIRPC="$(usex libtirpc)"

	if [[ "${PV}" != "9999" ]] ; then
		IFS='_' read -r MY_LIB_VERSION MY_LIB_TAG <<< "${PV}"

		my_makeopts=( "${my_makeopts[@]}"
			REVISION="${PV}"
			LIB_VERSION="${MY_LIB_VERSION}"
			LIB_TAG="${MY_LIB_TAG}"
		)
	fi
}

src_compile() {
	emake "${my_makeopts[@]}"
}

src_install() {
	emake "${my_makeopts[@]}" DESTDIR="${D}" install
	# Install docs
	einstalldocs # Bug 831705
	# Cleanup static libraries
	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die # Bug 783984
	fi
}
